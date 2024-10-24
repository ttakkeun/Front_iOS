//
//  ProfileType.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation

enum ProfileType: String, Codable {
    case cat = "CAT"
    case dog = "DOG"
    
    func toKorean() -> String {
        switch self {
        case .cat:
            return "고양이"
        case .dog:
            return "강아지"
        }
    }
}
