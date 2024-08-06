//
//  CreateProfileViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import Foundation
import Moya

@MainActor
class CreateProfileViewModel: ObservableObject {
    
    @Published var requestData: CreatePetProfileRequestData? = CreatePetProfileRequestData(name: "", type: .dog, variety: "", birth: "", neutralization: false)
    @Published var responseData: CreatePetProfileResponseData?
    public var isProfileCompleted: Bool = false{
        didSet {
            isProfileCompleted = isNameFilled && isTypeFilled && isVarietyFilled && isNeutralizationFilled
        }
    }
    
    private let provider: MoyaProvider<PetProfileAPITarget>
    
    //MARK: - INIT
    init(isProfileCompleted: Bool = false,
         provider: MoyaProvider<PetProfileAPITarget> = APIManager.shared.testProvider(for: PetProfileAPITarget.self)
    ) {
        self.isProfileCompleted = isProfileCompleted
        self.provider = provider
    }
    
    // MARK: - btnProperty
    /// 시작하기 버튼 활성화 여부 판단
    @Published public var isNameFilled: Bool = false
    @Published public var isTypeFilled: Bool = false
    @Published public var isVarietyFilled: Bool = false
    @Published public var isBirthFilled: Bool = false
    @Published public var isNeutralizationFilled: Bool = false
    
    
    //MARK: - API Function
    /// 로그인 데이터 전송
    /// - Parameter token: 인가 코드
    
    /// 펫 프로필 등록 결과 받아오기 핸들러 함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func petProfileHandleResponse(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(CreatePetProfileResponseData.self, from: response.data)
            DispatchQueue.main.async {
                self.responseData = decodedData /// Login에서 했던 것처럼 api response 각 응답(isSuccess, code, message, result, pet_id)을 CreatePetProfileResponseDate(isSuccess: decodedData.result.isSuccess, ...)처럼 각자 저장해줘야 하나?
                print("펫 프로필 등록 성공: \(String(describing: self.responseData))")
            }
        } catch {
            print("펫 프로필 등록 디코더 에러: \(error)")
        }
    }
}
