//
//  Icon.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    
    // MARK: - Login
    case appleLogin = "appleLogin"
    case logoBackground = "logoBackground"
    case logo = "logo"
    
    // MARK: - Profile
    case profileCat = "profileCat"
    case profileDog = "profileDog"
    case togetherPet = "togetherPet"
    
    // MARK: ETC
    case glass = "glass"
    case setting = "setting"
    case alarm = "alarm"
    
    // MARK: - ProfileMake
    case check = "check"
    case uncheck = "uncheck"
    case bottomArrow = "bottomArrow"
    
    // MARK: - Tab
    case home = "home"
    case diagnosis = "diagnosis"
    case schedule = "schedule"
    case suggestion = "suggestion"
    case qna = "qna"
    
    // MARK: - Home
    case changeCard = "changeCard"
    case pencil = "pencil"
    
    // MARK: - Todo
    case homeClaw = "homeClaw"
    case homeEar = "homeEar"
    case homeEye = "homeEye"
    case homeHair = "homeHair"
    case homeTeeth = "homeTeeth"
    case unCheckBox = "unCheckBox"
    case checkBox = "checkBox"
    case checkV = "checkV"
    
    // MARK: - Recommend
    case topRank = "topRank"
    case bottomRank = "bottomRank"
    
    // MARK: - Diagnosing
    case trash = "trash"
    
    var image: Image {
        return Image(self.rawValue)
    }
}
