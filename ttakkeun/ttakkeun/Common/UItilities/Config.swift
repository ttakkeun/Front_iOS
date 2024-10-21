//
//  Config.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation

@MainActor
enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist cannot be fount")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["BASE_URL"] as? String else {
            fatalError("BaseURL not found")
        }
        return baseURL
    }()
}
