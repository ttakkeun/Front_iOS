//
//  HomeProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import Foundation
import Moya
import SwiftUI

///홈프로필 카드 뷰 모델
@MainActor
class HomeProfileCardViewModel: ObservableObject, @preconcurrency HomePatchImage {
    
    @Published var profileData: HomeProfileResponseData?
    @Published var isShowFront:  Bool = true
    private let provider: MoyaProvider<PetProfileAPITarget>
    
    // MARK: - Init
    init(
        provider: MoyaProvider<PetProfileAPITarget> = APIManager.shared.createProvider(for: PetProfileAPITarget.self
        )
    ) {
        self.provider = provider
    }
    
    
    // MARK: - Function

    /// 날짜 형식 변환
    /// - Parameter dateString: 입력 받은 날짜 넣기
    /// - Returns: xxx.xxx.xxx 형식으로 넣어서 변환
    public func formattedData(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    // MARK: - API Function
    
    /// 홈 뷰의 프로필 카드 정보 받아오기
    /// - Parameter petId: 엔드포인트로 사용될 펫 Id
    public func getPetProfileInfo(petId: Int) {
        provider.request(.getHomeProfile(petId: petId)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleGetProfileInfo(response: response)
            case .failure(let error):
                print("홈 프로필 카드 받아오기 네트워크 오류: \(error)")
            }
        }
    }
    
    /// 홈 뷰의 프로필 카드 정보 핸들러
    /// - Parameter response: 받아온 데이터의 Response 처리
    private func handleGetProfileInfo(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<HomeProfileResponseData>.self, from: response.data)
            DispatchQueue.main.async {
                self.profileData = decodedData.result
                print("홈 프로필 카드 받아오기 성공")
            }
        }  catch {
            print("홈 프로필 카드 디코더 에러: \(error)")
        }
    }
    
    // MARK: - ImagePicker
    
    var profileImage: [UIImage] = []
    
    
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
    
    @Published var selectedImageCount: Int = 0
    
    func sendImageToServer(_ image: UIImage, _ id: Int) {
        patchPetProfileImage(image: image, id: id) { success in
            if success {
                self.getPetProfileInfo(petId: id)
            } else {
                print("이미지 받아오기 실해")
            }
            
        }
    }
    
    /// 프로필 홈 화면 프로필 이미지 직접 수정
    /// - Parameters:
    ///   - image: 추가한 이미지
    ///   - id: 펫 아이디
    ///   - completion: 성공 여부
    private func patchPetProfileImage(image: UIImage, id: Int, completion: @escaping (Bool) -> Void) {
        provider.request(.editProfileImage(petId: id, images: [image])) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(ResponseData<PetProfileImageResponseData>.self, from: response.data)
                    if decodedData.isSuccess {
                        if let url = decodedData.result?.petImageUrl {
                            print(url)
                        }
                        completion(true)
                    }
                } catch {
                    print("홈탭 프로필 사진 전달 디코더 에러: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("홈탭에서 프로필 사진 업데이트 네트워크 오류: \(error)")
                completion(false)
            }
        }
    }
}
