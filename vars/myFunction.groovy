#!/usr/bin/env groovy
def uploadAppToFirebase(String appName, String appBinary, String firebaseAppId, String distributionGroup = "testers", boolean withReleaseNotes = false, String releaseNotesFile = "") {
    echo "### sharedTools.uploadAppToFirebase - appName: ${appName}"
    script {
        // set msAppCenter distribution group for MVA10 apps only [MVACoreApp]
        // if (organisation == "MVACoreApp" && BRANCH_NAME ==~ /(support|stage)/) distributionGroup = "\"All MVA10\""
        // if (organisation == "MVACoreApp" && BRANCH_NAME == "test") distributionGroup = "\"All MVA10,Test\""
        // if (organisation == "MVACoreApp" && BRANCH_NAME == "production") distributionGroup = "\"All MVA10,Production\""
        // else distributionGroup = "testers"
        // Firebase App Distribution upload parameters
        firebaseUploadParams = "-f \"${appBinary}\" -a \"${firebaseAppId}\" -g \"${distributionGroup}\""
        
        // Add release notes if required
        // if (withReleaseNotes) {
        //     def CHANGELOG = "${env.WORKSPACE}/CHANGELOG.txt"
        //     if (fileExists(CHANGELOG) == false) {
        //         generateChangeLog("${CHANGELOG}", true)
        //     }
        //     echo "CHANGELOG:" + CHANGELOG
        //     firebaseUploadParams += " --release-notes-file ${CHANGELOG}"
        // }
        execute("resources/scripts/myFunction.sh", firebaseUploadParams)
    }
    echo "### sharedTools.uploadAppToFirebase - END"
}