//
//  ResponseData.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation

struct ResponseData<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}
