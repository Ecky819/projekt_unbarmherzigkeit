// android/app/build.gradle.kts - KORRIGIERTE VERSION

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services Plugin - WICHTIG: Am Ende der Plugin-Liste
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.projekt_unbarmherzigkeit"
    compileSdk = 34 // Explizit setzen für Firebase

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.projekt_unbarmherzigkeit"
        minSdk = 21  // Mindestens 21 für Firebase
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        
        // MultiDex Support für Firebase
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // MultiDex Support
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Firebase BOM - garantiert kompatible Versionen
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}