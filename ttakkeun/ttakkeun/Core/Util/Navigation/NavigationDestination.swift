//
//  NavigationDestination.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case signUp(socialType: SocialLoginType, singUpRequest: SignUpRequest) // 회원가입 페이지 이동
    case editPetProfile(editPetInfo: PetInfo, image: String) // 홈 화면 펫 프로파일의 수정 버트
    case makeJournalist // 일지 생성 네비게이션
    case productSearch
    case writeTipsView(category: ExtendPartItem)
    case myPage
}
