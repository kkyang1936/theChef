## Chef
### by Executive Chef
This project was built with Xcode 11.4 for iOS 13.4.

### Installation Instructions
* Clone the repository
* Open Chef2 in Xcode
* Right click on WatsonDeveloperCloud or IBMSwiftSDKCore in the bottom left, and Show in Finder
* Delete the swift-sdk and swift-sdk-core folders
* In Xcode go to Chef2 > PROJECT Chef2 > Swift Packages and remove swift-sdk or WatsonDeveloperCloud
* Add it back by clicking + and searching for WatsonDeveloperCloud. Choose swift-sdk by watosn-developer-cloud, version 3.3.0, and make sure you choose AssistantV2 and VisualRecognitionV3
* If there are build errors, fix them by right clicking on the file generating an error, choosing "Show in Finder", then replacing that source file with one of the same name from theChef/CustomSwiftSdkFiles
