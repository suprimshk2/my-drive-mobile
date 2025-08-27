// buildscript {
//     val kotlin_version = "1.9.22"
//     repositories {
//         google()
//         mavenCentral()
//     }

//     dependencies {
//         classpath("com.google.gms:google-services:4.4.1")
//         classpath("com.android.tools.build:gradle:8.2.2")
//         classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
//     }
// }

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)
// rootProject.buildDir = '../build'

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