allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fix root_detector namespace issue
// Apply namespace fix to root_detector package
subprojects {
    afterEvaluate {
        if (project.name == "root_detector") {
            try {
                val android = project.extensions.findByName("android")
                if (android != null) {
                    val androidExtension = android as com.android.build.gradle.BaseExtension
                    if (androidExtension.namespace == null || androidExtension.namespace.isEmpty()) {
                        androidExtension.namespace = "space.wisnuwiry.root_detector"
                        println("✅ Added namespace 'space.wisnuwiry.root_detector' to root_detector")
                    }
                }
            } catch (e: Exception) {
                println("⚠️  Could not set namespace for root_detector: ${e.message}")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
