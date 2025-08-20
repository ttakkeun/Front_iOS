//
//  DiagnoseService.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

class DiagnoseService: DiagnoseServiceProtocol, BaseAPIService {
    typealias Target = DiagnoseRouter
    
    var provider: Moya.MoyaProvider<DiagnoseRouter>
    var decoder: JSONDecoder
    var callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<DiagnoseRouter> = APIManager.shared.createProvider(for: DiagnoseRouter.self),
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postDiagnose(diagnose: DiagnoseAIRequest) -> AnyPublisher<ResponseData<DiagnoseAIResponse>, Moya.MoyaError> {
        request(.postDiagnose(diagnose: diagnose))
    }
    
    func patchUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, Moya.MoyaError> {
        request(.patchUserPoint)
    }
    
    func getDetailDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDetailResponse>, Moya.MoyaError> {
        request(.getDetailDiag(diagId: diagId))
    }
    
    func deleteDiag(diagId: Int) -> AnyPublisher<ResponseData<DiagnoseDeleteResponse>, Moya.MoyaError> {
        request(.deleteDiag(diagId: diagId))
    }
    
    func patchUpdateNaver(diagId: Int, data: DiagnoseNaverRequest) -> AnyPublisher<ResponseData<DiagnoseNaverResponse>, Moya.MoyaError> {
        request(.patchUpdateNaver(diagId: diagId, data: data))
    }
    
    func getDiagResultList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagnoseListResponse>, Moya.MoyaError> {
        request(.getDiagResultList(petId: petId, category: category, page: page))
    }
    
    func getUserPoint() -> AnyPublisher<ResponseData<DiagnosePointResponse>, Moya.MoyaError> {
        request(.getUserPoint)
    }
}
