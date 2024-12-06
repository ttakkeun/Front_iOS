//
//  NavigationDestination.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case signUp(singUpRequest: SignUpRequest) // 회원가입 페이지 이동
    case createProfile
    case editPetProfile(editPetInfo: PetInfo, image: String) // 홈 화면 펫 프로파일의 수정 버트
}
