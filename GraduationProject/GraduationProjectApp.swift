//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("signIn") var isSignIn = false

    @StateObject var taskStore = TaskStore()

  var body: some Scene {
    WindowGroup {
        if !isSignIn {
            LoginView()
        } else {
            MainView()
                .environmentObject(taskStore)
//            test()
      }
    }
  }
}
