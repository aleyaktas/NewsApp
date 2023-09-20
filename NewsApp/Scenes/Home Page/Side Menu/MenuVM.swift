//
//  MenuVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation


class MenuVM {
    
    var auth = AuthenticationManager()
    
    func uploadUserImage() -> URL? {
        let user = auth.getUserFromUserDefaults() ?? User()
        return user.avatarURL
    }
    
    func getFullName() -> String? {
        return auth.getUserFromUserDefaults()?.fullname
    }
    
}
