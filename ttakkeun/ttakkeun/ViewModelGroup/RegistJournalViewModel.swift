//
//  RegistJournalViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya
import SwiftUI

/// 일지 생성 시, 사용되는 일지 등록 뷰에서의 뷰모델
@MainActor
class RegistJournalViewModel: ObservableObject, @preconcurrency ImageHandling {
    
    /// 선택 답변이 저장되는 데이터 모델
    @Published var inputData: RegistJournalData
    /// API로 받아온 답변과 질문
    @Published var getQuestions: JournalQuestionsDetailData?
    
    
    @Published var currentPage: Int = 1
    @Published var selectedPart: PartItem?
    private let provider: MoyaProvider<JournalAPITarget>
    
    
    // MARK: - Init
    init(
        provider: MoyaProvider<JournalAPITarget> = APIManager.shared.createProvider(for: JournalAPITarget.self),
        petId: Int
    )
    {
        self.provider = provider
        self.inputData = RegistJournalData(petId: petId)
    }
    
    // MARK: - 일지 답변 서버 전달 API
    public func postInputData(completion: @escaping (Bool) -> Void) async  {
        
        guard let selectedPart = selectedPart else { return }
        
        provider.request(.registJournal(data: inputData, category: selectedPart.rawValue)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerResponsePostData(response: response, completion: completion)
            case .failure(let error):
                print("일정 생성 데이터 네트워크 에러: \(error)")
            }
        }
    }
    
    private func handlerResponsePostData(response: Response, completion: @escaping (Bool) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<RecordId>.self, from: response.data)
            if decodedData.isSuccess {
                if let id = decodedData.result?.recordID {
                    if self.questionImages.isEmpty {
                        completion(true)
                    } else {
                        self.sendImageMultiPart(recordId: id, completion: completion)
                    }
                }
            }
            print("일정 생성 데이터 디코더 완료 : \(decodedData)")
        } catch {
            print("일정 생성 데이터 디코더 에러 : \(error)")
            completion(false)
        }
    }
    
    // MARK: - 일지괸련 질문 및 답변 조회
    
    
    
    public func updateAnswer(for questionID: Int, selectedAnswer: [String]) {
        inputData.answers[questionID] = selectedAnswer
    }
    
    /// 현재 페이지에 해당하는 질문 조회
    var currentQuestion: QuestionDetailData? {
        guard let getQuestion = getQuestions, currentPage - 1 <= getQuestion.questions.count else { return nil }
        return getQuestion.questions[currentPage - 2]
    }
    
    
    
    // MARK: - 일지 질문 조회 API
    
    /// 서버로부터 질문과 답변을 조회한다.
    public func getJournalQuestions(completion: @escaping (Bool) -> Void) async {
        
        guard let selectedPart = selectedPart else { return }
        
        provider.request(.getJournalQuestions(category: selectedPart.rawValue)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerResponseGetQuestions(response: response)
                completion(true)
            case .failure(let error):
                print("카테고리 질문 네트워크 오류: \(error)")
                completion(false)
            }
        }
    }
    
    private func handlerResponseGetQuestions(response: Response) {
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
                              print("Received JSON: \(jsonString)")
                          }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<JournalQuestionsDetailData>.self, from: response.data)
            DispatchQueue.main.async {
                self.getQuestions = decodedData.result
                print("카테고리 \(String(describing: self.selectedPart?.rawValue)) 질문 받아오기 성공")
            }
        } catch {
            print("카테고리 질문 디코더 에러: \(error)")
        }
    }
    
    
    // MARK: - ImageAPI
    public func sendImageMultiPart(recordId: Int, completion: @escaping (Bool) -> Void ) {
        provider.request(.sendRecordImage(recordID: recordId, questionImages: questionImages)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.hasndlerResponseData(response: response, completion: completion)
            case .failure(let error):
                print("일지 사진 전달 네트워크 에러: \(error)")
            }
        }
    }
    
    private func hasndlerResponseData(response: Response, completion: @escaping (Bool) -> Void ) {
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
                   print("Received JSON: \(jsonString)")
               }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<[CreateJournalResponse]>.self, from: response.data)
            if decodedData.isSuccess {
                if let data = decodedData.result {
                    print("사진 전달 완료: (\(data)")
                }
                completion(true)
            }
        } catch {
            print("사진 전달 디코더 에러 \(error)")
            completion(false)
        }
    }
    
    
    // MARK: - ImagePicker
    
    @Published var isImagePickerPresented: Bool = false
    @Published var questionImages: [Int: [UIImage]] = [:]
    @Published var arrImages: [UIImage] = []
    
    /// 현재 선택된 이미지 수 반환
    var selectedImageCount: Int {
        guard let questionID = currentQuestion?.questionID else { return 0 }
        return questionImages[questionID]?.count ?? 0
    }
    
    
    func addImage(_ images: UIImage) {
        guard let questionID = currentQuestion?.questionID else { return }
        if questionImages[questionID]?.count ?? 0 < 5 {
            questionImages[questionID, default: []].append(images)
        }
    }
    
    func removeImage(at index: Int) {
        guard let questionID = currentQuestion?.questionID else { return }
        questionImages[questionID]?.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
        print(questionImages)
    }
    
    func getImages() -> [UIImage] {
        guard let questionID = currentQuestion?.questionID else { return [] }
        return questionImages[questionID] ?? []
    }
    
    // MARK: - Page Change
    
    /// 페이지 감소 버튼
    public func pageIncrease() {
        if currentPage < 6 {
            self.currentPage += 1
        }
    }
}
