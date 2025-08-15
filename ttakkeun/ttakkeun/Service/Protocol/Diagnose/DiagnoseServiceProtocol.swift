//
//  DiagnoseServiceProtocol.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Combine
import CombineMoya
import Moya

protocol DiagnoseServiceProtocol {
    func postDiagnose(diagnose: DiagnoseAIRequest) -> AnyPublisher<ResponseData<DiagnoseAIResponse>, MoyaError>
    
    func patchUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, MoyaError>
    
    func getDetailDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDetailResponse>, MoyaError>
    
    func deleteDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDeleteResponse>, MoyaError>
    
    func patchUpdateNaver(diagId: Int, data: DiagnoseNaverRequest) -> AnyPublisher<ResponseData<DiagnoseNaverResponse>, MoyaError>
    
    func getDiagResultList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagnoseListResponse>, MoyaError>
    
    func getUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, MoyaError>
}
