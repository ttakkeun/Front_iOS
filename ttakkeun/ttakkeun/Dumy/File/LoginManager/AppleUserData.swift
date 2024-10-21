//
//  AppleUserData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation

struct AppleUserData: Codable {
    var userIdentifier: String
    var fullName: String
    var email: String?
    var authorizationCode: String?
    var identityToken: String?
}

