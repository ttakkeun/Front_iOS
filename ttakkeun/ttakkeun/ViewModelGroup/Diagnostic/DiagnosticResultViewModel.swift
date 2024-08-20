//
//  DiagnosticResultViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import Foundation
import Moya

/// 진단 결과 관련 뷰모델, 진단 결과 처리 뷰모델
@MainActor
class DiagnosticResultViewModel: ObservableObject {
    
    @Published var point: Int = 0
    @Published var diagnosisData: DiagnosisData?
    
    private let provider: MoyaProvider<DiagnosticResultAPITarget>
    let petId: Int
    
    // MARK: - Init
    
    init(
        provider: MoyaProvider<DiagnosticResultAPITarget> = APIManager.shared.testProvider(for: DiagnosticResultAPITarget.self),
        petId: Int
    ) {
        self.provider = provider
        self.petId = petId
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
    
    // MARK: - 진단 결과 상세 조회 API
    /// 진단 내용 상세 데이터 조회
    /// - Parameter id: 진단 결과 id
    public func getDiagnosisDetail(id: Int) async {
        provider.request(.getDiagnosisDetail(diagnosisId: id)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerDiagnosticPoint(response: response)
            case .failure(let error):
                print("진단 상세 내부 데이터 네트워크 오류: \(error)")
            }
        }
    }
    
    /// 진단 상세 내용 조회 핸들러
    /// - Parameter response: response 데이터
    private func handlerDiagnosisDetail(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<DiagnosisData>.self, from: response.data)
            if decodedData.isSuccess {
                DispatchQueue.main.async {
                    self.diagnosisData = decodedData.result
                }
            } else {
                print(decodedData.message)
            }
        } catch {
            print("진단 상세 내부 데이터 디코더 에러: \(error)")
        }
    }
    
}
