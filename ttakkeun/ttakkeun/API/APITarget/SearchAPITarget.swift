//
//  ProductAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/10/24.
//

import Foundation
import Moya

enum SearchAPITarget {
    /* 검색 데이터 조회 */
    case searchNaverProduct(keyword: String)
    case searchLocalDBProduct(keyword: String, page: Int)
}

extension SearchAPITarget: APITargetType {
    var path: String {
        switch self {
        case .searchNaverProduct(let keyword):
            return "/api/product/search_naver/\(keyword)"
        case .searchLocalDBProduct(let keyword, let page):
            return "/api/product/search_db/\(keyword)/\(page)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchNaverProduct, .searchLocalDBProduct:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchLocalDBProduct, .searchNaverProduct:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
