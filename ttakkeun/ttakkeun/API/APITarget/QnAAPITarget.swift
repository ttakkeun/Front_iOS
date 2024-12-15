//
//  QnAAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Moya
import SwiftUI

enum QnAAPITarget {
    case getTipsAll(page: Int) // 전체 팁 조회
    case getTipsBest // Best 팁 조회
    case getTipsPart(category: PartItem.RawValue, page: Int) // 부위별 팁 조회
    case writeTips(data: WriteTipsRequest) // 팁 생성
    case patchTipsImage(tipId: Int, images: [UIImage]) // 팁 이미지 업로드 API
    case touchScrap(tipId: Int)
    case getMyWriteTips(page: Int)
    case getMyScrapTips(page: Int)
    case deleteMyTips(tipId: Int)
}

extension QnAAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getTipsAll:
            return "/api/tips/all"
        case .getTipsBest:
            return "/api/tips/best"
        case .getTipsPart:
            return "/api/tips"
        case .writeTips:
            return "/api/tips/add"
        case .patchTipsImage(let tipId, _):
            return "/api/tips/\(tipId)/images"
        case .touchScrap(let tipId):
            return "/api/tips/scrap/\(tipId)"
        case .getMyWriteTips:
            return "/api/tips/myTips"
        case .getMyScrapTips:
            return "/api/tips/myScraps"
        case .deleteMyTips(let tipId):
            return "/api/tips/\(tipId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTipsAll, .getTipsBest, .getTipsPart, .getMyScrapTips, .getMyWriteTips:
            return .get
        case .writeTips:
            return .post
        case .patchTipsImage, .touchScrap:
            return .patch
        case .deleteMyTips:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getTipsAll(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .getTipsBest:
            return .requestPlain
        case .getTipsPart(let category, let page):
            return .requestParameters(parameters: ["category": category, "page": page], encoding: URLEncoding.default)
        case .writeTips(let data):
            return .requestJSONEncodable(data)
        case .patchTipsImage(_, let images):
            var formData = [MultipartFormData]()
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let multipartData = MultipartFormData(
                        provider: .data(imageData),
                        name: "images",
                        fileName: "image_\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                    formData.append(multipartData)
                }
            }
            return .uploadMultipart(formData)
            
        case .touchScrap:
            return .requestPlain
            
        case .getMyWriteTips(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
            
        case .getMyScrapTips(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
            
        case .deleteMyTips:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .patchTipsImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
