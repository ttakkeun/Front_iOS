//
//  DiagnoseRouter.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Moya

enum DiagnoseRouter {
    /// AI 진단하기
    case postDiagnose(diagnose: DiagnoseAIRequest)
    /// 사용자 포인트 차감
    case patchUserPoint
    /// 진단서 상세 내용 조회
    case getDetailDiag(diagId: Int)
    /// 진단 삭제
    case deleteDiag(diagId: Int)
    /// 추천 제품 네이버 쇼핑 정보 업데이트
    case patchUpdateNaver(diagId: Int, data: DiagnoseNaverRequest)
    /// 진단 결과 목록 조회
    case getDiagResultList(petId: Int, category: PartItem.RawValue, page: Int)
    /// 사용자 포인트 조회
    case getUserPoint
}

extension DiagnoseRouter: APITargetType {
    var path: String {
        switch self {
        case .postDiagnose:
            return "/api/diagnose/loading"
        case .patchUserPoint:
            return "/api/diagnose/loading"
        case .getDetailDiag(let diagId):
            return "/api/diagnose/result/\(diagId)"
        case .deleteDiag(let diagId):
            return "/api/diagnose/result/\(diagId)"
        case .patchUpdateNaver(let diagId, _):
            return "/api/diagnose/result/\(diagId)"
        case .getDiagResultList(let petId, let category, let page):
            return "/api/diagnose/\(petId)/\(category)/\(page)"
        case .getUserPoint:
            return "/api/diagnose/point"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDiagnose:
            return .post
        case .patchUserPoint, .patchUpdateNaver:
            return .patch
        case .deleteDiag:
            return .delete
        default:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postDiagnose(let diagnose):
            return .requestJSONEncodable(diagnose)
        case .patchUpdateNaver(_, let diagnoseNaverRequest):
            return .requestJSONEncodable(diagnoseNaverRequest)
        case .patchUserPoint, .getDetailDiag:
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
