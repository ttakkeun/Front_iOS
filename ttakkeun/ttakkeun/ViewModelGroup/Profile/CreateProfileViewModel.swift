//
//  CreateProfileViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import Foundation
import Moya
import SwiftUI

///포로필 생성뷰 뷰모델
@MainActor
class CreateProfileViewModel: ObservableObject, @preconcurrency ImageHandling {
    
    @Published var requestData: CreatePetProfileRequestData? = CreatePetProfileRequestData(name: "", type: .dog, variety: "", birth: "", neutralization: false)
    @Published var responseData: CreatePetProfileResponseData?
    @Published var isProfileCompleted: Bool = false
    
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
    @Published public var isNameFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    @Published public var isTypeFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isVarietyFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isBirthFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isNeutralizationFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isProfileCompleted = isNameFilled && isTypeFilled && isVarietyFilled && isNeutralizationFilled
    }
    
    // MARK: - AppendImage Function
    func addImage(_ images: UIImage) {
        if !profileImage.isEmpty {
            profileImage.removeAll()
        }
        profileImage.append(images)
    }
    
    func removeImage(at index: Int) {
        profileImage.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        profileImage
    }
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int = 0
    
    var profileImage: [UIImage] = []
    
    
    //MARK: - API Function
    //TODO: - API Function 작성 필요함
    
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
