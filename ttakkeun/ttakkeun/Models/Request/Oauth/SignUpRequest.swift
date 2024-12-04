//
//  SignupData.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/25/24.
//

import Foundation

struct SignUpRequest: Codable, Equatable, Hashable {
    let identityToken: String
    var email: String
    var name: String
}
