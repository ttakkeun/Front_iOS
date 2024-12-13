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
    
    init(
        petName: String = "",
        petId: Int = 0
    ) {
        self.petName = petName
        self.petId = petId
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
}
