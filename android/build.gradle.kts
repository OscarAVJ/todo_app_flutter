// build.gradle.kts (Nivel raíz - android/build.gradle.kts)

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Manejo de carpetas de build con File (requerido en Kotlin DSL)
rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

// ✅ Añadir namespace si no está definido (útil para compatibilidad AGP 8+)
subprojects {
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android is com.android.build.gradle.BaseExtension && android.namespace == null) {
            android.namespace = project.group.toString()
        }
    }
}

// ✅ Tarea clean
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
