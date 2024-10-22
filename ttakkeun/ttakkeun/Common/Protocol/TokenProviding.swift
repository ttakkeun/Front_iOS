//
//  TokenProviding.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}
