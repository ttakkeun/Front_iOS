//
//  Icon.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    
    // MARK: - Close
    case close = "close"
    
    // MARK: - Login
    case appleLogin = "appleLogin"
    case kakaoLogin = "kakaoLogin"
    case loginBackground = "loginBackground"
    case petFriends = "petFriends"
    case uncheck = "uncheck"
    
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
    case tommorrow = "tommorrow"
    case changeDate = "changeDate"
    case nextTime = "nextTime"
    
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
    case leftCat = "leftCat"
    case rightDog = "rightDog"
    
    // MARK: - Tab
    case diagnosis = "diagnosis"
    case home = "home"
    case qna = "qna"
    case schedule = "schedule"
    case suggestion = "suggestion"
    
    //MARK: - MyPage
    case heartTips = "heartTips"
    case pencil = "pencil"
    
    var image: Image {
        return Image(self.rawValue)
    }
}
