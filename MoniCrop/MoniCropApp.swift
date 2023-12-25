//
//  MoniCropApp.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 12/2/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    FirebaseApp.configure()
    return true
  }
}

@main
struct MoniCropApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LandingPage()
        }
    }
}
