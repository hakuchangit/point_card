// dart >= 3
// deps: hive ^2.x, hive_flutter ^1.x
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FromJson<T> = T Function(JsonMap);
typedef ToJson<T> = JsonMap Function(T);

/// JSON <-> T の変換器（好きな実装でOK）
class JsonCodecT<T> {
  final FromJson<T> fromJson;
  final ToJson<T> toJson;
  const JsonCodecT({required this.fromJson, required this.toJson});
}

/// ライブラリ全体の初期化（複数回呼んでも安全）
class HiveUniversal {
  static bool _inited = false;

  static Future<void> init({String? path, bool flutter = true}) async {
    if (_inited) return;
    if (flutter) {
      try {
        await Hive.initFlutter(path);
      } catch (_) {}
    } else {
      try {
        Hive.init(path!);
      } catch (_) {}
    }
    _inited = true;
  }
}

/// 任意のコレクション（箱）に T を保存する“超薄い”汎用ストア。
/// - 値は JSON 文字列として Box<String> に保存
/// - キーはアプリが決める文字列（ID/パス/複合キーなど自由）
/// - 並び順が必要なら OrderIndex を併用（別クラス）
class BoxCollection<T> {
  final String namespace; // 例: "myapp_v1"
  final String collection; // 例: "users", "notes"
  final JsonCodecT<T> codec; //

  late final Box<String> _doc; // JSONを入れる箱（Box<String>）

  BoxCollection._({
    required this.namespace,
    required this.collection,
    required this.codec,
    required Box<String> doc,
  }) : _doc = doc;

  /// コレクションを開く（存在しなければ作られる）
  static Future<BoxCollection<T>> open<T>({
    required String namespace,
    required String collection,
    required JsonCodecT<T> codec,
  }) async {
    final name = '$namespace::$collection';
    // 戻り値はHive.openBox　ディスク上のnameに該当するファイルを探してくる
    final docBox = await Hive.openBox<String>(name);
    return BoxCollection._(
      namespace: namespace,
      collection: collection,
      codec: codec,
      doc: docBox,
    );
  }

  String _k(String id) => '$collection::$id';

  // ---- CRUD ----
  Future<void> put(String id, T value) async {
    await _doc.put(_k(id), jsonEncode(codec.toJson(value)));
  }

  Future<T?> get(String id) async {
    final s = _doc.get(_k(id));
    if (s == null) return null;
    try {
      final raw = jsonDecode(s);
      if (raw is Map<String, dynamic>) return codec.fromJson(raw);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(String id) async => _doc.delete(_k(id));

  /// まとめて保存
  Future<void> putAll(Map<String, T> entries) async {
    final map = <String, String>{};
    entries.forEach((id, v) => map[_k(id)] = jsonEncode(codec.toJson(v)));
    await _doc.putAll(map);
  }

  /// 簡易一覧（大量データ向きではない）
  Future<List<T>> list({int? limit, int? offset}) async {
    final vals = _doc.values;
    final out = <T>[];
    for (final s in vals.skip(offset ?? 0).take(limit ?? vals.length)) {
      try {
        final raw = jsonDecode(s);
        if (raw is Map<String, dynamic>) out.add(codec.fromJson(raw));
      } catch (_) {}
    }
    return out;
    // 大量データなら「全IDインデックス」や LazyBox の導入を検討
  }

  /// 監視（1件）
  Stream<T?> watchKey(String id) async* {
    final key = _k(id);
    yield await get(id);
    yield* _doc.watch(key: key).asyncMap((_) => get(id));
  }

  /// 監視（全体・簡易）
  Stream<List<T>> watchAll() async* {
    yield await list();
    yield* _doc.watch().asyncMap((_) => list());
  }

  Future<void> clear() async => _doc.clear();
  Future<void> close() async => _doc.close();
}

/// 並び順インデックス（必要な人だけ使う）
/// 任意の“スコープ”（例: "home_feed", "folder:xyz"）ごとに ID の配列を保持
class OrderIndex {
  final String namespace;
  final String name; // 例: "users_order", "notes_order"
  late final Box<List> _box;

  OrderIndex._(this.namespace, this.name, this._box);

  static Future<OrderIndex> open({
    required String namespace,
    required String name,
  }) async {
    final box = await Hive.openBox<List>('${namespace}::$name');
    return OrderIndex._(namespace, name, box);
  }

  String _k(String scope) => '$name::$scope';

  Future<List<String>> getOrder(String scope) async {
    final raw = _box.get(_k(scope));
    if (raw == null) return const [];
    return raw.map((e) => e.toString()).toList(growable: false);
  }

  Future<void> setOrder(String scope, List<String> ids) async {
    await _box.put(_k(scope), ids);
  }

  Future<void> clear() async => _box.clear();
  Future<void> close() async => _box.close();
}
