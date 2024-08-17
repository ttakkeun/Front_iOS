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
        provider: MoyaProvider<JournalAPITarget> = APIManager.shared.testProvider(for: JournalAPITarget.self),
        petId: Int
    )
    {
        self.provider = provider
        self.inputData = RegistJournalData(petId: petId)
    }
    
    // MARK: - 일지 답변 서버 전달 API
    public func postInputData() async {
        
        //TODO: inputData 내용 채워야한다.
        
        provider.request(.registJournal(data: inputData)) { [weak self] result in
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
    
    // MARK: - 일지괸련 질문 및 답변 조회
    
    /// 사용자가 선택한 답변의 데이터 모델에 저장한다.
    /// - Parameters:
    ///   - questionIndex: 질문 인덱스 번호
    ///   - selectedAnswer: 선택한 답변 조회
    public func updateAnswer(for questionIndex: Int, selectedAnswer: [String]) {
        
        switch questionIndex {
        case 0:
            inputData.answer1 = selectedAnswer
        case 1:
            inputData.answer2 = selectedAnswer
        case 3:
            inputData.answer3 = selectedAnswer
        default:
            break
        }
    }
    
    /// 현재 페이지에 해당하는 질문 조회
    var currentQuestion: QuestionDetailData? {
        guard let getQuestion = getQuestions, currentPage - 1 <= getQuestion.questions.count else { return nil }
        return getQuestion.questions[currentPage - 2]
    }
    
    
    
    // MARK: - 일지 질문 조회 API
    
    /// 서버로부터 질문과 답변을 조회한다.
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
                print("카테고리 \(String(describing: self.selectedPart?.rawValue)) 질문 받아오기 성공")
            }
        } catch {
            print("카테고리 질문 디코더 에러: \(error)")
        }
    }
    
    
    // MARK: - ImagePicker
    
    @Published var isImagePickerPresented: Bool = false
    @Published var questionImages: [Int: [UIImage]] = [:]
    @Published var arrImages: [UIImage] = []
    
    /// 현재 선택된 이미지 수 반환
    var selectedImageCount: Int {
        return questionImages[currentPage - 2]?.count ?? 0
    }
    
    
    func addImage(_ images: UIImage) {
        if questionImages[currentPage - 2]?.count ?? 0 < 5 {
            questionImages[currentPage - 2, default: []].append(images)
        }
    }
    
    func removeImage(at index: Int) {
        questionImages[currentPage - 2]?.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        return questionImages[currentPage - 2] ?? []
    }
    
    // MARK: - Page Change
    
    /// 페이지 감소 버튼
    public func pageIncrease() {
        if currentPage < 5 {
            self.currentPage += 1
        }
    }
}
