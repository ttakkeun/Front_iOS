//
//  SearchType.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import Foundation

enum SearchType: String {
    case naver = "해당 상품을 찾지 못했습니다. \n다른 키워드로 검색해보세요!"
    case local = "결과가 없습니다. 상품이 아직 등록되지 않았을 수 있습니다."
    
    var loadingText: String {
        switch self {
        case .naver:
            return "외부 상품 정보를 가져오는 중입니다."
        case .local:
            return "내부 상품 정보를 가져오는 중입니다."
        }
    }
}
