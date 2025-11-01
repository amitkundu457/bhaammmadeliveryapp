import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory
//buildscript {
//    repositories {
//        google()
//        mavenCentral()
//    }
//    dependencies {
//        // Flutter build dependency
//        classpath "com.android.tools.build:gradle:8.1.0"
//
//        // ✅ Add this for Firebase
//        classpath 'com.google.gms:google-services:4.4.0'
//    }
//}
// 1️⃣ Allprojects repositories
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 2️⃣ Custom build directory outside project
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)
dependencies {
//    implementation("com.google.firebase:firebase-messaging:25.0.1")
}

// 3️⃣ Subprojects build directory
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 4️⃣ Ensure subprojects evaluate after :app
subprojects {
    project.evaluationDependsOn(":app")
}

// 5️⃣ Override clean task to delete custom build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
