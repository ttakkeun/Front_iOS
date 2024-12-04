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
}
