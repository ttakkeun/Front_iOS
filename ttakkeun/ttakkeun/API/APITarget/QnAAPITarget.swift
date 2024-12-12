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
    case getTipsAll(page: Int)
    case getTipsBest
    case getTipsPart(category: PartItem.RawValue, page: Int)
    case writeTips(data: WriteTipsRequest)
    case patchTipsImage(tipId: Int, images: [UIImage])
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTipsAll, .getTipsBest, .getTipsPart:
            return .get
        case .writeTips:
            return .post
        case .patchTipsImage:
            return .patch
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
