//
//  MyPageViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/11/24.
//

import Foundation
import Moya

///마이페이지 프로필 확인 뷰 모델
@MainActor
class MyPageViewModel: ObservableObject {
    @Published var profileData: HomeProfileData?
    private let provider: MoyaProvider<PetProfileAPITarget>
    
    // MARK: - Init
    init(provider: MoyaProvider<PetProfileAPITarget> = APIManager.shared.testProvider(for: PetProfileAPITarget.self)
    ) {
        self.provider = provider
    }
    
    
    // MARK: - Function

    /// 날짜 형식 변환
    /// - Parameter dateString: 입력 받은 날짜 넣기
    /// - Returns: 0000년 00월 00일 형식으로 넣어서 변환
    public func formattedData(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy년 MM월 dd일"
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    // MARK: - API Function
    
    /// 홈 뷰의 프로필 카드 정보 받아오기
    /// - Parameter petId: 엔드포인트로 사용될 펫 Id
    public func getPetProfileInfo(petId: Int) async {
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
            let decodedData = try JSONDecoder().decode(HomeProfileData.self, from: response.data)
            DispatchQueue.main.async {
                self.profileData = decodedData
                print("홈 프로필 카드 받아오기 성공")
            }
        }  catch {
            print("홈 프로필 카드 디코더 에러: \(error)")
        }
    }
}


