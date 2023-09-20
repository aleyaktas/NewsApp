//
//  AuthenticationManager.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 18.09.2023.
//

import Foundation

struct User: Codable {
    var fullname: String?
    var email: String?
}

class AuthenticationManager {
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
        print("user deleted")
          UserDefaults.standard.removeObject(forKey: "user")
      }
}

