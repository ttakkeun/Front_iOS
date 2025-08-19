//
//  AppStorageKey.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/12/25.
//

import Foundation

/// 앱 스토리지 값 키
enum AppStorageKey: CaseIterable {
    static let userNickname = "UserNickname"
    static let userEmail = "UserEmail"
    static let userName = "UserName"
    static let userLoginType = "UserLoginType"
    static let petName = "PetName"
    static let petId = "PetId"
    static let petType = "PetType"
    static let aiCount = "AICount"
    
    static let allKeys: [String] = [
        userNickname, userEmail, userName, userLoginType,
        petName, petId, petType, aiCount
    ]
}
