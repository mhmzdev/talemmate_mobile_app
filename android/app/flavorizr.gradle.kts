import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor")

    productFlavors {
        create("stage") {
            dimension = "flavor"
            applicationId = "dev.mhmz.taleemmate.stage"
            resValue(type = "string", name = "app_name", value = "TL-Stage")
            signingConfig = signingConfigs.getByName("stage")
        }
        create("qa") {
            dimension = "flavor"
            applicationId = "dev.mhmz.taleemmate.qa"
            resValue(type = "string", name = "app_name", value = "TL-QA")
            signingConfig = signingConfigs.getByName("stage")
        }
        create("prod") {
            dimension = "flavor"
            applicationId = "dev.mhmz.taleemmate"
            resValue(type = "string", name = "app_name", value = "TaleemMate")
            signingConfig = signingConfigs.getByName("prod")
        }
    }
}