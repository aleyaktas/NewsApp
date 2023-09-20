//
//  LoginVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//



import Foundation
import Firebase

class LoginVM {
    
    var authManager = AuthenticationManager()

    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
               if let error = error {
                   print("User login failed: \(error.localizedDescription)")
                   completion(false, error.localizedDescription)
               } else {
                   print("User logged in successfully!")
                   self.fetchUserData(email: email)
                   completion(true, nil)
               }
           }
       }
       
    private func fetchUserData(email: String) {
        if let user = Auth.auth().currentUser {
            let db = Database.database().reference()
            let userRef = db.child("users").child(user.uid)
            
            userRef.getData() { (error, snapshot) in
                if let error = error {
                    print("Failed to retrieve user data: \(error.localizedDescription)")
                } else {
                    if let userData = snapshot?.value as? [String: Any],
                       let fullname = userData["fullname"] as? String {
                        print("Full Name: \(fullname)")
                        let newUser = User(fullname: fullname, email: email)
                        self.authManager.saveUserToUserDefaults(user: newUser)
                    }
                }
            }
        }
    }
}
