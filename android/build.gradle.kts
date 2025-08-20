// android/build.gradle.kts - KOMPLETT ÜBERARBEITETE VERSION

buildscript {
    dependencies {
        classpath("com.android.tools.build:gradle:8.7.3")
        classpath("com.google.gms:google-services:4.3.15")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ENTFERNE DIESE FEHLERHAFTEN ZEILEN:
// - apply plugin: 'com.google.gms.google-services'
// - android { ... } Block
// Diese gehören in android/app/build.gradle.kts!