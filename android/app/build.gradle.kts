import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.mobiking.wholesale"
    compileSdk = 36
    ndkVersion = "29.0.14033849"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID[](https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mobiking.wholesale"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Enable multiDex for apps with many methods
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            val keyPropertiesFile = rootProject.file("key.properties")

            if (keyPropertiesFile.exists()) {
                val properties = Properties()
                keyPropertiesFile.inputStream().use {
                    properties.load(it)
                }

                keyAlias = properties["keyAlias"] as String
                keyPassword = properties["keyPassword"] as String
                storeFile = file(properties["storeFile"] as String)
                storePassword = properties["storePassword"] as String
            }
            // If key.properties doesn't exist, do nothing.
            // Release builds will only work when the client provides it.
        }
    }

    buildTypes {
        debug {
            // Uses Android's default debug keystore.
            // No signing configuration needed.
        }

        release {
            if (rootProject.file("key.properties").exists()) {
                signingConfig = signingConfigs.getByName("release")
            }

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packagingOptions {
        jniLibs.useLegacyPackaging = true
    }
}

flutter {
    source = "../.."
}

// Add dependencies outside the 'android' block
dependencies {
    // Required for core library desugaring (Java 8+ API support on older Android)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
