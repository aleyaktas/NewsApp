//
//  AccountVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation
import Firebase


class AccountVM {
    
    private var auth = AuthenticationManager()
    private var user: User?
    
    func fetchUserData() {
         if let storedUser = auth.getUserFromUserDefaults() {
             user = User(fullname: storedUser.fullname ?? "Empty", email: storedUser.email ?? "Empty")
         }
     }
     
     func updateUser(fullname: String, completion: @escaping (Bool, String) -> Void) {
         if let user = Auth.auth().currentUser {
             let db = Database.database().reference()
             let userRef = db.child("users").child(user.uid)
             
             userRef.updateChildValues(["fullname": fullname]) { (error, _) in
                 if let error = error {
                     completion(false, error.localizedDescription)
                 } else {
                     self.user?.fullname = fullname
                     self.auth.saveUserToUserDefaults(user: User(fullname: fullname, email: user.email))
                     NotificationCenter.default.post(name: NSNotification.Name("updateFullName"), object: nil)
                     completion(true, "Profile successfully updated")
                 }
             }
         } else {
             completion(false, "User not authenticated")
         }
     }
}
