//
//  FireAuth.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

struct FireAuth {
    static let share = FireAuth()
    
    private init() { }
    
    func signinWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            guard error == nil else {
                completion(error)
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            Auth.auth().signIn(with: credential) { result, error in guard error == nil else {
                completion(error)
                return
            }
                print("SIGN IN")
                UserDefaults.standard.set(true, forKey: "signIn")
            }
        }
    }
}
