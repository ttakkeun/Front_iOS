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
    case togetherPet = "togetherPet"
    case ProfileCat = "ProfileCat"
    case ProfileDog = "ProfileDog"
    case check = "check"
    
    // MARK: - Home
    case editProfile = "editProfile"
    case homeClaw = "homeClaw"
    case homeEar = "homeEar"
    case homeEye = "homeEye"
    case homeHair = "homeHair"
    case homeTeeth = "homeTeeth"
    case changeCard = "changeCard"
    case topRank = "topRank"
    case bottomRank = "bottomRank"
    
    // MARK: - ETC
    case alarm = "alarm"
    case setting = "setting"
    case glass = "glass"
    case write = "write"
    case cancel = "cancel"
    case camera = "camera"
    
    // MARK: - Schedule
    case downArrow = "downArrow"
    case neutral = "neutral"
    case sad = "sad"
    case hinghing = "hinghing"
    case soso = "soso"
    case smile = "smile"
    case heart = "heart"
    case unCheckBox = "unCheckBox"
    case checkBox = "checkBox"
    case checkV = "checkV"
    
    // MARK: - Diagnosis
    case buttonClaw = "buttonClaw"
    case buttonEar = "buttonEar"
    case buttonEye = "buttonEye"
    case buttonHair = "buttonHair"
    case buttonTeeth = "buttonTeeth"
    case answerCheck = "answerCheck"
    case answerNotCheck = "answerNotCheck"
    case petCamera = "petCamera"
    case imageRemove = "imageRemove"
    case diagnosisBackground = "diagnosisBackground"
    case bubble = "bubble"
    case bubbleLogo = "bubbleLogo"
    case trash = "trash"
    case loadingBg = "loadingBg"
    
    var image: Image {
        return Image(self.rawValue)
    }
}
