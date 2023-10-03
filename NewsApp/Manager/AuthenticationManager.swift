//
//  AuthenticationManager.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 18.09.2023.
//

import Foundation

final class AuthenticationManager {
    func saveUserToUserDefaults(user: User) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedData, forKey: "user")
        }
    }

    func getUserFromUserDefaults() -> User? {
        if let savedData = UserDefaults.standard.data(forKey: "user"),
           let user = try? JSONDecoder().decode(User.self, from: savedData) {
            return user
        }
        return nil
    }
    
    func deleteUserFromUserDefaults() {
          UserDefaults.standard.removeObject(forKey: "user")
      }
    
    func saveAvatarURLToUserDefaults(avatarURL: URL, for user: inout User) {
        user.avatarURL = avatarURL
        saveUserToUserDefaults(user: user)
    }
    
    func deleteAvatarURLFromUserDefaults(for user: inout User) {
        user.avatarURL = nil
        saveUserToUserDefaults(user: user)
    }
}

