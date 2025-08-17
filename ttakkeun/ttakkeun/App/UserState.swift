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
        UserDefaults.standard.setValue(userName, forKey: AppStorageKey.userNickname)
    }
    
    public func setUserEmail(_ userEmail: String) {
        UserDefaults.standard.setValue(userEmail, forKey: AppStorageKey.userEmail)
    }
    
    public func setLoginType(_ loginType: SocialLoginType) {
        UserDefaults.standard.setValue(loginType.rawValue, forKey: AppStorageKey.userLoginType)
    }
    
    public func getPetId() -> Int {
        return self.petId
    }
    
    public func getPetName() -> String {
        return self.petName
    }

    public func getUserName() -> String {
        guard let userName = UserDefaults.standard.string(forKey: AppStorageKey.userNickname) else {
            return "닉네임 정보 없음"
        }
        
        return userName
    }
    
    public func getLoginType() -> SocialLoginType {
        if let loginTypeRawValue = UserDefaults.standard.string(forKey: AppStorageKey.userLoginType),
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
