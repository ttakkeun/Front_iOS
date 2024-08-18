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
    case sendTipsImage(images: [UIImage])
    case createTipsContent(data: QnaTipsRequestData)
    case heartChange(tip_id: Int)
}

extension QnaTipsAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .createTipsContent:
            return "/tips/add"
        case .sendTipsImage(_):
            return "/tips/add"
        case .getQnaTips:
            return "/tips"
        case .heartChange(let tip_id):
            return "/tips/like/\(tip_id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTipsContent, .sendTipsImage:
            return .post
        case .getQnaTips:
            return .get
        case .heartChange:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getQnaTips:
            return .requestPlain
        case .heartChange:
            return .requestPlain
        case .createTipsContent(let data):
            return .requestJSONEncodable(data)
        case .sendTipsImage(let images):
            var multipartData = [MultipartFormData]()
            
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "image\(index).jpg", mimeType: "image/jpg"))
                }
            }
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getQnaTips, .createTipsContent, .heartChange:
            return ["Content-Type": "application/json"]
        case .sendTipsImage:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getQnaTips:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": {
                    "tips": [
                        {
                            "tip_id": 1,
                            "category": "EAR",
                            "author": "홍길동",
                            "popular": true,
                            "title": "귀 청소하는 방법",
                            "content": "귀는 자주 청소해야 합니다.",
                            "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                            "created_at": "2024-08-18T08:00:00Z",
                            "recommend_count": 15
                        },
                        {
                            "tip_id": 2,
                            "category": "EAR",
                            "author": "박영희",
                            "popular": false,
                            "title": "귀 건강 관리",
                            "content": "귀를 깨끗하게 유지하는 것이 중요합니다.",
                            "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                            "created_at": "2024-08-09T10:30:00Z",
                            "recommend_count": 10
                        },
                        {
                            "tip_id": 3,
                            "category": "EYE",
                            "author": "김철수",
                            "popular": true,
                            "title": "눈 건강 지키기",
                            "content": "눈은 주기적으로 검사해야 합니다.",
                            "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                            "created_at": "2024-08-08T12:00:00Z",
                            "recommend_count": 25
                        },
                        {
                            "tip_id": 4,
                            "category": "EYE",
                            "author": "이순신",
                            "popular": true,
                            "title": "눈의 피로를 줄이는 방법",
                            "content": "장시간 화면을 보면 눈이 피로해집니다.",
                            "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                            "created_at": "2024-08-08T14:45:00Z",
                            "recommend_count": 20
                        },
                        {
                            "tip_id": 5,
                            "category": "HAIR",
                            "author": "이영희",
                            "popular": true,
                            "title": "털 관리 비법",
                            "content": "빗질을 자주 해주면 좋습니다.",
                            "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg", "https://example.com/image2.jpg"],
                            "created_at": "2024-08-07T08:00:00Z",
                            "recommend_count": 50
                        }
                    ]
                }
            }
            """
            return Data(json.utf8)
            
        case .createTipsContent:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": {
                    "tip_id": 11,
                    "category": "EAR",
                    "created_at": "2024-08-11T00:00:00Z"
                }
            }
            """
            return Data(json.utf8)
            
        case .sendTipsImage:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Image upload success",
                "result": {
                    "image": "https://example.com/uploaded_image.jpg"
                }
            }
            """
            return Data(json.utf8)
            
        case .heartChange:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Heart change successful",
                "result": {
                    "total_likes": 36,
                    "isLike": true
                }
            }
            """
            return Data(json.utf8)
        }
    }
}
