//
//  PetState.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

/// 선택된 펫 정보 관리, 스케줄에서 펫 선택 이후 호출
class PetState: ObservableObject {
    @Published var petName: String
    @Published var petId: Int
    
    init(petName: String = "", petId: Int = 0) {
        self.petName = petName
        self.petId = petId
    }
    
    /// 펫 아이디 수정 함수
    /// - Parameter id: 펫 아이디 입력
    public func setId(_ id: Int) {
        self.petId = id
    }
    
    /// 펫 이름 수정
    /// - Parameter name: 펫 이름 입력
    public func setName(_ name: String) {
        self.petName = name
    }
}
