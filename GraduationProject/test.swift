import Foundation
import SwiftUI
import FirebaseCore
import Firebase // 添加 Firebase 模塊
import GoogleSignIn

struct test: View {
    @State private var user: FirebaseAuth.User? // 使用 @State 或 @StateObject 宣告 user

    var body: some View {
        
        Text("Hello, World!")
            .onAppear {
                // 在 View 加載時初始化 user
                self.user = Auth.auth().currentUser
                
                if let user = self.user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    var multiFactorString = "MultiFactor: "
                    for info in user.multiFactor.enrolledFactors {
                        multiFactorString += info.displayName ?? "[DispayName]"
                        multiFactorString += " "
                        print("uid:\(uid)")
                        print("email:\(email ?? "no")")
                        print("phptoURL:\(photoURL as Any)")
                        print("multiFactorString:\(multiFactorString)")
                    }
                    // ...
                }
            }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
