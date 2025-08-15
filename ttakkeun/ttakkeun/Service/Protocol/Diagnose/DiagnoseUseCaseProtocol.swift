//
//  DiagnoseUseCaseProtocol.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

protocol DiagnoseUseCaseProtocol {
    func executePostDiagnose(diagnose: DiagnoseAIRequest) -> AnyPublisher<ResponseData<DiagnoseAIResponse>, MoyaError>
    
    func executePatchUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, MoyaError>
    
    func executeGetDetailDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDetailResponse>, MoyaError>
    
    func executeDeleteDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDeleteResponse>, MoyaError>
    
    func executePatchUpdateNaver(diagId: Int, data: DiagnoseNaverRequest) -> AnyPublisher<ResponseData<DiagnoseNaverResponse>, MoyaError>
    
    func executeGetDiagResultList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagnoseListResponse>, MoyaError>
    
    func executeGetUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, MoyaError>
}
