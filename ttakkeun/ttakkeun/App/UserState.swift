//
//  UserState.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/22/24.
//

import Foundation

class UserState: ObservableObject {
    
    static let shared = UserState()
    
    private var petName: String
    private var petId: Int
    
    private var loginType: SocialLoginType
    
    init(
        petName: String = "",
        petId: Int = 0,
        loginType: SocialLoginType = .apple
    ) {
        self.petName = petName
        self.petId = petId
        self.loginType = loginType
    }
    
    public func setPetId(_ petId: Int) {
        self.petId = petId
    }
    
    public func setPetName(_ petName: String) {
        self.petName = petName
    }
    
    public func setUserName(_ userName: String) {
        UserDefaults.standard.setValue(userName, forKey: "UserNickname")
    }
    
    public func setUserEmail(_ userEmail: String) {
        UserDefaults.standard.setValue(userEmail, forKey: "UserEmail")
    }
    
    public func setLoginType(_ loginType: SocialLoginType) {
        UserDefaults.standard.setValue(loginType.rawValue, forKey: "UserLoginType")
    }
    
    public func getPetId() -> Int {
        return self.petId
    }
    
    public func getPetName() -> String {
        return self.petName
    }
    
    public func getUserName() -> String {
        guard let userName = UserDefaults.standard.string(forKey: "UserNickname") else {
            return "닉네임 정보 없음"
        }
        
        return userName
    }
    
    public func getUserEmail() -> String {
        guard let userEmail = UserDefaults.standard.string(forKey: "UserEmail") else {
            return "이메일 정보 없음"
        }
        
        return userEmail
    }
    
    public func getLoginType() -> SocialLoginType {
        if let loginTypeRawValue = UserDefaults.standard.string(forKey: "UserLoginType"),
           let loginType = SocialLoginType(rawValue: loginTypeRawValue) {
            return loginType
        }
        return .apple
    }
    
    public func clearProfile() {
        self.petName = ""
        self.petId = 0
    }
}
