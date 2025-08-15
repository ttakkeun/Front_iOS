//
//  AppleDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct AppleLoginRequest: Codable, Equatable, Hashable {
    let identityToken: String
    var email: String
    var name: String
}
