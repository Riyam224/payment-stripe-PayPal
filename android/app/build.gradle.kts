plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin must be applied after Android and Kotlin Gradle plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.stripe_paypal_payment"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.stripe_paypal_payment"
        minSdk = 21 // ✅ Minimum required for flutter_stripe
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // For now, use debug keys so `flutter run --release` works
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Ensure these repositories are available for Stripe dependencies
repositories {
    google()
    mavenCentral()
}
