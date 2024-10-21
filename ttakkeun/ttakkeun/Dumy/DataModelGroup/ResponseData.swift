//
//  ResponseData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/19/24.
//

import Foundation

/// ResponseData 구조, 뷰모델 내부 API 호출 상황에서 사용할 것
struct ResponseData<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}
