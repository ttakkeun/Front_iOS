//
//  APIBaseURL.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/9/24.
//

import Foundation
import Moya

/// baseURL 설정
protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        return URL(string: "http://ttakkeun.com:8080/api")!
    }
}
