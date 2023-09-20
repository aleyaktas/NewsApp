//
//  AccountVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class AccountVM {
    
    private var auth = AuthenticationManager()
    private var user: User?
    
    func fetchUserData() {
         if let storedUser = auth.getUserFromUserDefaults() {
             user = User(fullname: storedUser.fullname ?? "Empty", email: storedUser.email ?? "Empty")
         }
     }
    
    func getUser() -> User? {
        return auth.getUserFromUserDefaults()
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
    
    func uploadUserImage() -> URL? {
        let user = auth.getUserFromUserDefaults() ?? User()
        return user.avatarURL
    }
    
    func uploadProfilePhoto(image: UIImage, completion: @escaping (URL?) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child("profile_photos/\(Auth.auth().currentUser!.uid).jpg")
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Upload image error: \(error)")
                    completion(nil)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        print("URL: \(downloadURL)")
                        var user = self.auth.getUserFromUserDefaults() ?? User()
                        self.auth.saveAvatarURLToUserDefaults(avatarURL: downloadURL, for: &user)
                        NotificationCenter.default.post(name: NSNotification.Name("updateProfileImage"), object: nil)
                        completion(downloadURL)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
}
