//
//  DiagnosticResultViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import Foundation
import Moya

@MainActor
class DiagnosticResultViewModel: ObservableObject {
    @Published var point: Int = 0
    
    private let provider: MoyaProvider<DiagnosticResultAPITarget>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<DiagnosticResultAPITarget> = APIManager.shared.testProvider(for: DiagnosticResultAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - 진단 포인트 API
    
    /// 진단 포인트 get API 함수
    public func getDiagnosticPoint() async {
        provider.request(.getPoint) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerDiagnosticPoint(response: response)
            case .failure(let error):
                print("진단 포인트 네트워크 에러 : \(error)")
            }
        }
    }
    
    /// 진단 포인트 핸들러 함수
    /// - Parameter response: response 값
    private func handlerDiagnosticPoint(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(DiagnosticPoint.self, from: response.data)
            DispatchQueue.main.async {
                self.point = decodedData.result.point
                print("진단 포인트 조회 완료")
            }
        } catch {
            print("진단 포인트 디코더 에러 : \(error)")
        }
    }
    
}
