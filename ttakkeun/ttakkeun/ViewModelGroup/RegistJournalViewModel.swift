//
//  RegistJournalViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya
import SwiftUI

@MainActor
class RegistJournalViewModel: ObservableObject, @preconcurrency ImageHandling {
    
    @Published var inputData: RegistJournalData?
    @Published var getQuestions: JournalQuestionsDetailData?
    
    
    @Published var currentPage: Int = 1
    @Published var selectedPart: PartItem?
    private let provider: MoyaProvider<JournalAPITarget>
    
    
    // MARK: - Init
    init(provider: MoyaProvider<JournalAPITarget> = APIManager.shared.testProvider(for: JournalAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - 일지 답변 저장
    public func postInputData() async {
        
        guard let data = self.inputData else { return }
        
        provider.request(.registJournal(data: data)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerResponsePostData(response: response)
            case .failure(let error):
                print("일정 생성 데이터 네트워크 에러: \(error)")
            }
        }
    }
    
    private func handlerResponsePostData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(RegistJournalResponseData.self, from: response.data)
            print("일정 생성 데이터 디코더 완료 : \(decodedData)")
        } catch {
            print("일정 생성 데이터 디코더 에러 : \(error)")
        }
    }
    
    // MARK: - 일지 질문 조회 API
    
    public func getJournalQuestions() async {
        
        guard let selectedPart = selectedPart else { return }
        
        provider.request(.getJournalQuestions(category: selectedPart)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerResponseGetQuestions(response: response)
            case .failure(let error):
                print("카테고리 질문 네트워크 오류: \(error)")
            }
        }
    }
    
    private func handlerResponseGetQuestions(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(JournalQuestionsData.self, from: response.data)
            DispatchQueue.main.async {
                self.getQuestions = decodedData.result
                print("카테고리 질문 받아오기 성공")
            }
        } catch {
            print("카테고리 질문 디코더 에러: \(error)")
        }
    }
    
    
    // MARK: - ImagePicker
    
    @Published var isImagePickerPresented: Bool = false
    @Published var arrImages: [UIImage] = []
    var selectedImageCount: Int {
        arrImages.count
    }
    
    
    func addImage(_ images: UIImage) {
        arrImages.append(images)
    }
    
    func removeImage(at index: Int) {
        if arrImages.indices.contains(index) {
            arrImages.remove(at: index)
        }
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        arrImages
    }
}
