// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_card_stamp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointCardStampAdapter extends TypeAdapter<PointCardStamp> {
  @override
  final int typeId = 0;

  @override
  PointCardStamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointCardStamp(
      id: fields[0] as String,
      pointCardId: fields[1] as String,
      stampNumber: fields[2] as int,
      isStamped: fields[3] as bool,
      stampUrl: fields[4] as String?,
      stampedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PointCardStamp obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pointCardId)
      ..writeByte(2)
      ..write(obj.stampNumber)
      ..writeByte(3)
      ..write(obj.isStamped)
      ..writeByte(4)
      ..write(obj.stampUrl)
      ..writeByte(5)
      ..write(obj.stampedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointCardStampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
