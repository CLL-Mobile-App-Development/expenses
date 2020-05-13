# Personal Expenses Tracker

* Description  

Simple single-screen app to track your personal expenses. The basic app is actually a project from an online Flutter/Dart course
being taught by *Maximilian Schwarzmüller*. The original app has logic to adapt to device orientation and accordingly display content on the scree. However, it only has add operation for expense items and only works with in-app data stored within an array.

The current version of the app has additional functionality to perform edit/delete operations on the desired expense item, with 
Cloud Firestore as backend data store.

                                                         
<img src="https://github.com/BODF-Mobile-App-Development/personal-expenses-tracker/blob/master/Personal_Expenses_Tracker_Final.gif" alt="Personal-Expenses-App-Gif" width=500px height=875px/>


***

* Installation

Apart from the normal process of installing an Android app on an emulator or actual device, two additional steps are needed
specific to this app.

1. If your android version < 5.0 (API level 21), _Multidex_ should be enabled in app-level _build.gradle_ file. Reason       being that the Dalvik executable (android's run-time until version 5.0) generated for this version of app has referenced methods in excess of 64K. That is the default limit set for Dalvik's executable (DEX file) in order to restrict the app (.apk file) to have a single DEX file.

_Multidex_ is a way to allow multiple DEX files in the app executable.

More information is available in below link, along with the required settings in app-level _build.gradle_ file:  
[Enable multidex for apps with over 64K methods](https://developer.android.com/studio/build/multidex)

*sample app-level gradle configuration file (within android/app folder) setting to enable multidex*:

    android {
        defaultConfig {
            ...
            minSdkVersion 15    // version number is < 21
            targetSdkVersion 28
            multiDexEnabled true // New line to be added to enable Multidex
        }
        ...
    }

    dependencies {
    // include below line only if your project had not been created with project type(-t option) set to AndroidX
    implementation 'com.android.support:multidex:1.0.3'

    // include below two lines only if your project had the project type(-t option) set to AndroidX at the creation time
    def multidex_version = "2.0.1"
    implementation 'androidx.multidex:multidex:$multidex_version'

    ...
    }


More details on migrating android projects to AndroidX can be found here: [AndroidX Migration](https://flutter.dev/docs/development/androidx-migration)




2. Register app to Firebase Cloud Firestore. Necessary Cloud Firestore files and settings to be included in the project will be available as part of the Firebase account set-up and app registration process. 

During the app set-up process on Firebase, a _google-services.json_ file will be created with information like your api-key, which is to be downloaded and included in the android project's app folder path. That file would be used to enable app connection with Cloud Firestore and perform different data operations through its api. Additional settings would also be required in the *project-level* and *app-level* *build.gradle* files. All of that information will be given to you during the set-up process.

Here is the link to Google Firebase: [Firebase](https://firebase.google.com/)