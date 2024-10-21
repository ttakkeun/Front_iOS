//
//  ProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import Foundation
import SwiftUI
import Moya

/// 프로필 선택 뷰 - 카드 뷰 뷰모델
@MainActor
class ProfileCardViewModel: ObservableObject {
    
    let provider: MoyaProvider<PetProfileAPITarget>
    let colors: [Color] = [Color.card001_Color, Color.card002_Color, Color.card003_Color, Color.card004_Color, Color.card005_Color, Color.primaryColor_Main]
    private var container: DIContainer
    
    @Published var petProfileData: PetProfileResult?
    @Published var backgroundColor: Color = .white
    @Published var isLastedCard: Bool = false
    @Published var titleName: String = ""
    
    private var usedColors: [Color] = []
    
    // MARK: - Init
    
    init(provider: MoyaProvider<PetProfileAPITarget> = APIManager.shared.createProvider(for: PetProfileAPITarget.self),
         petProfileData: PetProfileResult? = nil,
         container: DIContainer
    ) {
        self.provider = provider
        self.petProfileData = petProfileData
        self.container = container
    }
    
    // MARK: - Init
    
    /// 유저에게 등록된 프로필 데이터 받아오기 API
    public func getPetProfile() async {
        provider.request(.getPetProfile) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerPetProfile(response: response)
            case .failure(let error):
                print("펫 프로필 받아오기 네트워크 오류: \(error)")
            }
        }
    }
    
    /// 펫 프로필 받아오기 핸들러 함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func handlerPetProfile(response: Response) {
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                       print("Received JSON: \(jsonString)")
                   }
            
            let decodedData = try JSONDecoder().decode(ResponseData<PetProfileResult>.self, from: response.data)
            DispatchQueue.main.async {
                self.petProfileData = decodedData.result
                self.checkResultData(data: self.petProfileData)
                print("펫 프로필 받아오기 성공")
            }
        } catch {
            print("펫 프로필 받아오기 디코더 에러: \(error)")
        }
    }
    
    private func checkResultData(data: PetProfileResult?) {
        if let data = data, !data.result.isEmpty {
            self.isLastedCard = false
            self.titleName = data.result.first?.name ?? ""
            print(data)
        } else {
            self.isLastedCard = true
        }
    }
    
    public func updateBackgroundColor() async {
        if usedColors.count == colors.count {
            usedColors.removeAll()
        }
        
        var newColor: Color
        
        repeat {
            newColor = colors.randomElement()!
        } while usedColors.contains(newColor)
        
        usedColors.append(newColor)
        withAnimation(.easeInOut(duration: 0.5)) {
            self.backgroundColor = newColor
        }
    }
    
    // MARK: - Navigation
    
    public func goToCreateProfile() async {
        self.container.navigationRouter.push(to: .createProfile)
    }
}
