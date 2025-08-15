// android/app/build.gradle.kts

import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android") // or id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropsFile = rootProject.file("key.properties")
val keystoreProps = Properties().apply {
    if (keystorePropsFile.exists()) load(keystorePropsFile.inputStream())
}

android {
    namespace = "com.hakuchan.point_card"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.hakuchan.point_card"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // ★ 必ず "release" を作る
        create("release") {
            if (keystorePropsFile.exists()) {
                // 正規の keystore（Play へ出す用）
                storeFile = file(keystoreProps["storeFile"] as String)
                storePassword = keystoreProps["storePassword"] as String
                keyAlias = keystoreProps["keyAlias"] as String
                keyPassword = keystoreProps["keyPassword"] as String
                enableV1Signing = true
                enableV2Signing = true
                enableV3Signing = true
            } else {
                // フォールバック：key.properties が無い時は debug キーで仮署名（ローカル確認用）
                val home = System.getProperty("user.home")
                storeFile = file("$home/.android/debug.keystore")
                storePassword = "android"
                keyAlias = "androiddebugkey"
                keyPassword = "android"
            }
        }
    }

    buildTypes {
        getByName("release") {
            // ★ ここが存在する "release" を参照するのでエラーが解消される
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        // debug はデフォルトのままでOK
    }
}

flutter { source = "../.." }
