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
    private var userName: String
    
    init(
        petName: String = "",
        petId: Int = 0,
        userName: String = ""
    ) {
        self.petName = petName
        self.petId = petId
        self.userName = userName
    }
    
    public func setPetId(_ petId: Int) {
        self.petId = petId
    }
    
    public func setPetName(_ petName: String) {
        self.petName = petName
    }
    
    public func setUserName(_ userName: String) {
        self.userName = userName
    }
    
    public func getPetId() -> Int {
        return self.petId
    }
    
    public func getPetName() -> String {
        return self.petName
    }
    
    public func getUserName() -> String {
        return self.userName
    }
}
