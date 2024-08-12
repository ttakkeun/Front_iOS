//
//  QnaTipsAPITarget.swift
//  ttakkeun
//
//  Created by 한지강 on 8/11/24.
//


import Foundation
import Moya
import SwiftUI

enum QnaTipsAPITarget {
    case getQnaTips
    case createTipsContent(data: QnaTipsData)
}

extension QnaTipsAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttakkeun.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getQnaTips:
            return "/tips-content/"
        case .createTipsContent(let data):
            return "/tips-content/add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQnaTips:
            return .get
        case .createTipsContent:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getQnaTips:
            return .requestPlain
        case .createTipsContent(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getQnaTips, .createTipsContent:
            return ["Content-Type": "application/json"]
            }
        }
    
    
//    var sampleData: Data {
//        switch self {
//        case .createTipsContent(let data):
//            let json
//        }
//    }
    
}
