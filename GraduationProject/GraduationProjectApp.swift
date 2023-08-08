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
    @AppStorage("uid") private var uid:String = ""
    
    @StateObject var taskStore = TaskStore()
    struct UserData: Decodable {
        var id: String
        var email: String
        var message: String
    }
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        UserDefaults.standard.set("", forKey: "uid")
                    }
                
            } else {
                MainView()
                    .environmentObject(taskStore)
                    .onAppear() {
                        print("AppView-AppStorageUid:\(uid)")
//                        AppStorage()
                    }
                
            }
        }
    }
   public func AppStorage() {

        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }

//        let url = URL(string: "http://127.0.0.1:8888/account/login.php")!
        let url = URL(string: "http://163.17.136.73:443/account/AppStorage.php")!
//        let url = URL(string: "http://10.21.1.164:8888/account/login.php")!
//        let url = URL(string: "http://163.17.136.73:443/account/login.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = ["uid": uid]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(UserData.self, from: data)
                    if userData.message == "no such account" {
                        print("============== AppView ==============")
                        print("login - userDate:\(userData)")
                        print(userData.message)
                        print("帳號或密碼輸入錯誤")
//                        errorMessage1 = "帳號或密碼輸入錯誤"
                        print("============== AppView ==============")
                    } else {
                        print("============== AppView ==============")
                        print("login - userDate:\(userData)")
                        print("使用者ID為：\(userData.id)")
                        print("使用者帳號為：\(userData.email)")
//                        UserDefaults.standard.set(true, forKey: "signIn")
//                        UserDefaults.standard.set("\(userData.id)", forKey: "uid")
                        print("============== AppView ==============")
//                        UserDefaults.standard.set(true, forKey: "signIn")
                    }
                } catch {
                    print("AppView-解碼失敗：\(error)")
//                    errorMessage1 = "登入有誤"
                }
            }
            // 測試
            //            guard let data = data else {
            //                print("No data returned from server.")
            //                return
            //            }
            //            if let content = String(data: data, encoding: .utf8) {
            //                print(content)
            //            }
        }
        .resume()
    }
//
}
