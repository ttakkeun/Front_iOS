//
//  QnaTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI
import Moya
import Foundation

@MainActor
class QnaTipsViewModel: ObservableObject {
    
    @Published var getTips: [QnaTipsResponseData] = []
    @Published var selectedCategory: TipsCategorySegment = .best
    
    private let provider: MoyaProvider<QnaTipsAPITarget>
    
    //MARK: - Init
    init(provider: MoyaProvider<QnaTipsAPITarget> = APIManager.shared.testProvider(for: QnaTipsAPITarget.self)) {
           self.provider = provider
           self.selectedCategory = .best
       }
    
    // 더미 데이터 업데이트
    @Published var tips: [QnaTipsResponseData] = []
   
     /// 전체, 인기 세그먼트 분류하기 위한 필터
     public var filteredTips: [QnaTipsResponseData] {
         switch selectedCategory {
         case .all:
             return tips.sorted { $0.elapsedTime < $1.elapsedTime }
         case .best:
             return tips.sorted { $0.heartNumber ?? 0 > $1.heartNumber ?? 0 }
         default:
             return tips.filter { $0.category.rawValue == selectedCategory.rawValue }
         }
     }
    
    //MARK: - API Function
    public func getQnaTipsData() async {
        print("getQnaTipsData called") // 확인용 print
        provider.request(.getQnaTips) { [weak self] result in
            switch result {
            case .success(let response):
                print("API 호출 성공") // 확인용 print
                self?.handlerResponseGetTipsData(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }

    private func handlerResponseGetTipsData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(QnaTipsData.self, from: response.data)
            DispatchQueue.main.async {
                self.tips = decodedData.result
                print("디코딩된 데이터: \(decodedData)") // 확인용 print
            }
        } catch {
            print("카테고리 질문 디코더 에러: \(error)")
        }
    }
}


/// 팁화면에 대한 카테고리들
enum TipsCategorySegment: String, Codable, CaseIterable, Identifiable {
    case all = "ALL"
    case best = "BEST"
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case tooth = "TOOTH"
    case etc = "ETC"
    
    
    var id: String{ self.rawValue}
    
    /// 부위 항목 서버에서 영어로 돌려받는다. 그 결과를 뷰에 보이기 위해 한글로 전환
       /// - Returns: 번역된 한글 값 전달
       func toKorean() -> String {
           switch self {
           case .all:
               return "전체"
           case .best:
               return "BEST"
           case .ear:
               return "귀"
           case .eye:
               return "눈"
           case .hair:
               return "털"
           case .claw:
               return "발톱"
           case .tooth:
               return "이빨"
           case .etc:
               return "기타"
           }
    }
}


