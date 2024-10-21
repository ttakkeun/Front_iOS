//
//  NavigationDestination.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/14/24.
//

import Foundation

/// 네비게이션 도착지 설정
enum NavigationDestination: Hashable {
    case signUp(token: String, name: String, email: String)
    case createProfile
    case myPage
    case createDiagnosis(petId: Int)
}
