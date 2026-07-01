import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use(keystoreProperties::load)
}
val isReleaseBuild =
    gradle.startParameter.taskNames.any { it.contains("release", ignoreCase = true) }
if (isReleaseBuild) {
    if (!keystorePropertiesFile.exists()) {
        throw GradleException(
            "Release signing requires android/key.properties. " +
                "See android/RELEASE_SIGNING_GUIDE.md.",
        )
    }
    val requiredSigningProperties =
        listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
    val missingSigningProperties =
        requiredSigningProperties.filter { keystoreProperties.getProperty(it).isNullOrBlank() }
    if (missingSigningProperties.isNotEmpty()) {
        throw GradleException(
            "android/key.properties is missing: ${missingSigningProperties.joinToString()}.",
        )
    }
}

android {
    // TODO: change namespace to production ID before first release (see RELEASE_SIGNING_GUIDE.md)
    namespace = "com.quantumlab.mathtutor.gb"
    compileSdk = 36   // flutter.compileSdkVersion resolves to 36 in Flutter 3.41.2
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: set per-flavor applicationId before release (see docs/store_readiness/PACKAGE_ID_PLAN.md)
        applicationId = "com.quantumlab.mathtutor.gb"
        minSdk = 24     // flutter.minSdkVersion in Flutter 3.41.2
        targetSdk = 36  // flutter.targetSdkVersion in Flutter 3.41.2
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let(::file)
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
