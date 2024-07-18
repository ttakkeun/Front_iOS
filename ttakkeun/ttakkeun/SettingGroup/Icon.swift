//
//  Icon.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    case home = "logo"
    case diagnosis = "diagnosis"
    case schedule = "schedule"
    case sugeestion = "sugeestion"
    case qna = "qna"
    
    // MARK: - Login
    case appleLogin = "appleLogin"
    case kakaoLogin = "kakaoLogin"
    case loginBackground = "loginBackground"
    case petFriends = "petFriends"
    
    
    // MARK: - Profile
    case ProfileCreate = "ProfileCreate"
    case ProfileCat = "ProfileCat"
    case ProfileDog = "ProfileDog"
    
    // MARK: - Home
    case editProfile = "editProfile"
    case homeClaw = "homeClaw"
    case homeEar = "homeEar"
    case homeEye = "homeEye"
    case homeHair = "homeHair"
    case homeTeeth = "homeTeeth"
    
    var image: Image {
        return Image(self.rawValue)
    }
}
