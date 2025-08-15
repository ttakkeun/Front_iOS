//
//  DiagnoseRouter.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Moya

enum DiagnoseRouter {
    case makeDiagnosis(data: CreateDiagRequst) // AI 진단하기
    case updateNaverDiag(data: DiagResultResponse) // 추천 제품 네이버 쇼핑 정보로 업데이트
    case getDiagResult(diagId: Int) // 진단서 상세 내용 조회
    case getDiagList(petId: Int, category: PartItem.RawValue, page: Int)
    case getUserPoint
    case patchUserPoint
}
