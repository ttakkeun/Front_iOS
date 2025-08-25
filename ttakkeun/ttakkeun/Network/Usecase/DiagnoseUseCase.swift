//
//  DiagnoseUseCase.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Combine
import CombineMoya
import Moya

class DiagnoseUseCase: DiagnoseUseCaseProtocol {
    private let service: DiagnoseServiceProtocol
    
    init(service: DiagnoseServiceProtocol = DiagnoseService()) {
        self.service = service
    }
    
    /// AI 진단하기
    func executePostDiagnose(diagnose: DiagnoseAIRequest) -> AnyPublisher<ResponseData<DiagnoseAIResponse>, Moya.MoyaError> {
        return service.postDiagnose(diagnose: diagnose)
    }
    
    /// 사용자 포인트 차감
    func executePatchUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, Moya.MoyaError> {
        return service.patchUserPoint()
    }
    
    /// 진단서 상세 내용 조회
    func executeGetDetailDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDetailResponse>, Moya.MoyaError> {
        return service.getDetailDiag(diagId: diagId)
    }
    
    /// 진단 삭제
    func executeDeleteDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDeleteResponse>, Moya.MoyaError> {
        return service.deleteDiag(diagId: diagId)
    }
    
    /// 추천 제품 네이버 쇼핑 정보로 업데이트
    func executePatchUpdateNaver(diagId: Int, data: DiagnoseNaverRequest) -> AnyPublisher<ResponseData<DiagnoseNaverResponse>, Moya.MoyaError> {
        return service.patchUpdateNaver(diagId: diagId, data: data)
    }
    
    /// 진단 결과 목록 조회
    func executeGetDiagResultList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagnoseListResponse>, Moya.MoyaError> {
        return service.getDiagResultList(petId: petId, category: category, page: page)
    }
    
    ///사용자 포인트 조회
    func executeGetUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, Moya.MoyaError> {
        return service.getUserPoint()
    }
    
}
