//
//  QnaTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI
import Moya
import Foundation

/// 공유된 Tip 내용들을 받아오는 기능들이 모여있는 뷰모델
@MainActor
class QnaTipsViewModel: ObservableObject {
    
    @Published var allTips: [QnaTipsResponseData] = []
    @Published var selectedCategory: TipsCategorySegment = .best {
        didSet {
            guard oldValue != selectedCategory else { return }
            currentPage = 0
            hasMoreData = true
            _Concurrency.Task {
                await reloadDataForCategory()
            }
        }
    }
    @Published var totalLikes: Int = 0
    @Published var heartClicked: Bool = false
    
    private let provider: MoyaProvider<QnaTipsAPITarget>
    private var currentPage = 0
    private let pageSize = 21
    private var hasMoreData = true
    
    //MARK: - Init
    init(provider: MoyaProvider<QnaTipsAPITarget> = APIManager.shared.testProvider(for: QnaTipsAPITarget.self)) {
        self.provider = provider
        self.selectedCategory = .best
    }
  
    //MARK: - API Function
    /// Tip내용들 Get요청 보내는 함수
    public func getQnaTipsData() async {
        guard hasMoreData else { return }
        
        switch selectedCategory {
        case .all:
            provider.request(.getAllTips(page: currentPage, size: pageSize)) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.handlerResponseGetTipsData(response: response)
                case .failure(let error):
                    print("네트워크 오류: \(error)")
                }
            }
        case .best:
            provider.request(.getBestTips(page: currentPage, size: pageSize)) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.handlerResponseGetTipsData(response: response)
                case .failure(let error):
                    print("네트워크 오류: \(error)")
                }
            }
        default:
            provider.request(.getTips(category: selectedCategory.rawValue, page: currentPage, size: pageSize)) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.handlerResponseGetTipsData(response: response)
                case .failure(let error):
                    print("네트워크 오류: \(error)")
                }
            }
        }
    }
    
    /// 특정 카테고리를 위한 데이터 재로드 함수
    public func reloadDataForCategory() async {
        allTips = []
        currentPage = 0
        hasMoreData = true
        await getQnaTipsData()
    }

    /// Tip내용들 받아오는 핸들러함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func handlerResponseGetTipsData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(QnaTipsData.self, from: response.data)
            DispatchQueue.main.async {
                self.allTips.append(contentsOf: decodedData.result)
                self.currentPage += 1
                self.hasMoreData = decodedData.result.count == self.pageSize
                print("Tips API 호출 성공")
            }
        } catch {
            print("카테고리 질문 디코더 에러: \(error)")
        }
    }
    
    /// Patch로 하트 수 변경 요청하고 전체 하트 수와 변경값 받아오는 함수
    public func patchHeartChange(tip_id: Int) async {
           provider.request(.heartChange(tip_id: tip_id)) { [weak self] result in
               switch result {
               case .success(let response):
                   print("하트변경 API 호출 성공")
                   self?.handlerResponsePatchHeartChange(response: response)
                   if self?.selectedCategory == .best {
                       self?.refreshBestTips()
                   }
               case .failure(let error):
                   print("네트워크 오류: \(error)")
               }
           }
       }
    
    /// best세그먼트 다시갱신
    private func refreshBestTips() {
            allTips = []
            currentPage = 0
            hasMoreData = true
            _Concurrency.Task {
                await getQnaTipsData()
            }
        }
    
    /// 하트 변경 점 받아오는 핸들러 함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func handlerResponsePatchHeartChange(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(QnaHeartChangeData.self, from: response.data)
            DispatchQueue.main.async {
                self.heartClicked = decodedData.result.isLike
                self.totalLikes = decodedData.result.total_likes
            }
        } catch {
            print("하트 변경 디코더 에러: \(error)")
        }
    }
}
