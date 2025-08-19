allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
buildscript {
    dependencies {
        // Existing dependencies...
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Am Ende der Datei hinzufügen:
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 34  // Mindestens 33
    
    defaultConfig {
        minSdkVersion 21  // Mindestens 21 für Firebase
        targetSdkVersion 34
        // ...
    }
}