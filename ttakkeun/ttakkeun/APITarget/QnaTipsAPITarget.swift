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
    case sendfTipsImage(images: [UIImage])
    case createTipsContent(data: QnaTipsRequestData)
}

extension QnaTipsAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .createTipsContent(let data):
            return "/tips/add"
        case .sendfTipsImage(_):
            return "/tips/add-image"
        case .getQnaTips:
            return "/tips/load"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTipsContent, .sendfTipsImage:
            return .post
        case .getQnaTips:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getQnaTips:
            return .requestPlain
        case .createTipsContent(let data):
            return .requestJSONEncodable(data)
        case .sendfTipsImage(let images):
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
        case .getQnaTips, .createTipsContent:
            return ["Content-Type": "application/json"]
        case .sendfTipsImage:
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
                   "result": [
                       {
                           "category": "EAR",
                           "title": "귀 청소하는 방법",
                           "content": "귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하귀는 자주 청소해야 합니다그렇죠 귀는 자주 청소해야죠 하하하하.",
                           "userName": "홍길동",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 30,
                           "heartNumber": 15
                       },
                       {
                           "category": "EAR",
                           "title": "귀 건강 관리",
                           "content": "귀를 깨끗하게 유지하는 것이 중요합니다.",
                           "userName": "박영희",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 45,
                           "heartNumber": 10
                       },
                       {
                           "category": "EYE",
                           "title": "눈 건강 지키기",
                           "content": "눈은 주기적으로 검사해야 합니다.",
                           "userName": "김철수",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 120,
                           "heartNumber": 25
                       },
                       {
                           "category": "EYE",
                           "title": "눈의 피로를 줄이는 방법",
                           "content": "장시간 화면을 보면 눈이 피로해집니다.",
                           "userName": "이순신",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 150,
                           "heartNumber": 20
                       },
                       {
                           "category": "HAIR",
                           "title": "털 관리 비법",
                           "content": "빗질을 자주 해주면 좋습니다.",
                           "userName": "이영희",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 240,
                           "heartNumber": 50
                       },
                       {
                           "category": "HAIR",
                           "title": "모발 윤기 유지하기",
                           "content": "건강한 식습관이 중요합니다.",
                           "userName": "정우성",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 270,
                           "heartNumber": 40
                       },
                       {
                           "category": "TOOTH",
                           "title": "이빨 관리 꿀팁",
                           "content": "매일 양치질을 해야 합니다.",
                           "userName": "조정석",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 90,
                           "heartNumber": 30
                       },
                       {
                           "category": "TOOTH",
                           "title": "치아 건강 유지하기",
                           "content": "정기적으로 치과에 방문해야 합니다.",
                           "userName": "배수지",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 110,
                           "heartNumber": 35
                       },
                       {
                           "category": "CLAW",
                           "title": "발톱 깎는 법",
                           "content": "발톱은 주기적으로 깎아야 합니다.",
                           "userName": "송강호",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 60,
                           "heartNumber": 20
                       },
                       {
                           "category": "CLAW",
                           "title": "발톱 건강 유지하기",
                           "content": "발톱을 깨끗하게 유지하세요.",
                           "userName": "안성기",
                           "image": "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                           "elapsedTime": 80,
                           "heartNumber": 18
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
                       "category": "EAR",
                       "title": "귀 청소하는 방법",
                       "content": "귀는 자주 청소해야 합니다.",
                       "userName": "홍길동",
                       "elapsedTime": 30,
                       "heartNumber": 15
                   }
               }
               """
            return Data(json.utf8)
            
        case .sendfTipsImage:
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
        }
    }
}
