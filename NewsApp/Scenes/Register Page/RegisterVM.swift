//
//  RegisterVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation
import Firebase
import FirebaseDatabase

class RegisterVM {
    
    private let authManager = AuthenticationManager()
    
    func registerUser(fullname: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("User registration failed: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                if let user = Auth.auth().currentUser {
                    self.saveUserData(id: user.uid, fullname: fullname, email: email) { success, errorMessage in
                        if success {
                            completion(true, nil)
                        } else {
                            completion(false, errorMessage)
                        }
                    }
                }
            }
        }
    }
    
    private func saveUserData(id: String, fullname: String, email: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Database.database().reference()
        let userRef = db.child("users").child(id)
        
        let userData: [String: Any] = [
            "fullname": fullname,
            "email": email
        ]
        
        userRef.setValue(userData) { (error, ref) in
            if let error = error {
                print("User information could not be saved: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                print("User information has been successfully saved!")
                let newUser = User(fullname: fullname, email: email)
                self.authManager.saveUserToUserDefaults(user: newUser)
                completion(true, nil)
            }
        }
    }
}


