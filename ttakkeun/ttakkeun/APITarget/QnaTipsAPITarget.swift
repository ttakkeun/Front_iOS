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
    case getTips(category: String, page: Int, size: Int)
    case getAllTips(page: Int, size: Int)
    case getBestTips(page: Int, size: Int)
    case sendTipsImage(tip_id: Int, images: [UIImage])
    case createTipsContent(data: QnaTipsRequestData)
    case heartChange(tip_id: Int)
}

extension QnaTipsAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .createTipsContent:
            return "/tips/add"
        case .sendTipsImage(let tip_id, _):
            return "/tips/\(tip_id)/images"
        case .getTips:
            return "/tips"
        case .getAllTips:
            return "/tips/all"
        case .getBestTips:
            return "/tips/best"
        case .heartChange(let tip_id):
            return "/tips/like/\(tip_id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTipsContent:
            return .post
        case .sendTipsImage:
            return .patch
        case .getTips, .getAllTips, .getBestTips:
            return .get
        case .heartChange:
            return .patch
        }
    }
    
    var task: Task {
           switch self {
           case .getTips(let category, let page, let size):
               return .requestParameters(parameters: ["category": category, "page": page, "size": size], encoding: URLEncoding.queryString)
           case .getAllTips(let page, let size):
               return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.queryString)
           case .getBestTips(let page, let size):
               return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.queryString)
           case .createTipsContent(let data):
               return .requestJSONEncodable(data)
           case .sendTipsImage(_, let images):
               var multipartData = [MultipartFormData]()
               for (index, image) in images.enumerated() {
                   if let imageData = image.jpegData(compressionQuality: 1.0) {
                       multipartData.append(MultipartFormData(provider: .data(imageData), name: "images", fileName: "image\(index).jpg", mimeType: "image/jpg"))
                   }
               }
               return .uploadMultipart(multipartData)
           case .heartChange:
               return .requestPlain
           }
       }
    
    var headers: [String : String]? {
        switch self {
        case .createTipsContent, .getTips, .getAllTips, .getBestTips, .heartChange:
            return ["Content-Type": "application/json"]
        case .sendTipsImage:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getAllTips:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "tip_id": 1,
                        "category": "EAR",
                        "author": "홍길동",
                        "popular": true,
                        "title": "귀 청소하는 방법",
                        "content": "귀는 자주 청소해야 합니다.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-08-18T08:00:00Z",
                        "recommend_count": 15,
                        "isLike": true
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
                        "recommend_count": 25,
                        "isLike": false
                    },
                    {
                        "tip_id": 4,
                        "category": "HAIR",
                        "author": "이민지",
                        "popular": false,
                        "title": "머리카락 관리법",
                        "content": "머리카락은 주기적으로 트리트먼트를 해주면 좋습니다.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-07-22T09:00:00Z",
                        "recommend_count": 5,
                        "isLike": false
                    },
                    {
                        "tip_id": 5,
                        "category": "TOOTH",
                        "author": "최현우",
                        "popular": true,
                        "title": "치아 건강을 위한 팁",
                        "content": "하루에 두 번 양치질을 하고, 정기적으로 치과를 방문하세요.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-06-30T14:15:00Z",
                        "recommend_count": 20,
                        "isLike": true
                    }
                ]
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
                    "created_at": "2024-08-11T00:00:00Z",
                    "isLike": false
                }
            }
            """
            return Data(json.utf8)
            
        case .getBestTips:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "tip_id": 1,
                        "category": "EAR",
                        "author": "홍길동",
                        "popular": true,
                        "title": "귀 청소하는 방법",
                        "content": "귀는 자주 청소해야 합니다.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-08-18T08:00:00Z",
                        "recommend_count": 15,
                        "isLike": true
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
                        "recommend_count": 25,
                        "isLike": false
                    },
                    {
                        "tip_id": 5,
                        "category": "TOOTH",
                        "author": "최현우",
                        "popular": true,
                        "title": "치아 건강을 위한 팁",
                        "content": "하루에 두 번 양치질을 하고, 정기적으로 치과를 방문하세요.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-06-30T14:15:00Z",
                        "recommend_count": 20,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .getTips:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "tip_id": 1,
                        "category": "EAR",
                        "author": "홍길동",
                        "popular": true,
                        "title": "귀 청소하는 방법",
                        "content": "귀는 자주 청소해야 합니다.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-08-18T08:00:00Z",
                        "recommend_count": 15,
                        "isLike": true
                    },
                    {
                        "tip_id": 210,
                        "category": "EAR",
                        "author": "박영희",
                        "popular": false,
                        "title": "귀 건강 관리",
                        "content": "귀를 깨끗하게 유지하는 것이 중요합니다.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-08-09T10:30:00Z",
                        "recommend_count": 10,
                        "isLike": false
                    },   
                    {
                        "tip_id": 5,
                        "category": "TOOTH",
                        "author": "최현우",
                        "popular": true,
                        "title": "치아 건강을 위한 팁",
                        "content": "하루에 두 번 양치질을 하고, 정기적으로 치과를 방문하세요.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-06-30T14:15:00Z",
                        "recommend_count": 20,
                        "isLike": true
                    },   
                    {
                        "tip_id": 5,
                        "category": "CLAW",
                        "author": "최현우",
                        "popular": true,
                        "title": "치아 건강을 위한 팁",
                        "content": "하루에 두 번 양치질을 하고, 정기적으로 치과를 방문하세요.",
                        "image_url": ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
                        "created_at": "2024-06-30T14:15:00Z",
                        "recommend_count": 20,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .sendTipsImage:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Image upload success",
                "result": [
                    "https://example.com/uploaded_image1.jpg",
                    "https://example.com/uploaded_image2.jpg"
                ]
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
