//
//  HomeProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import Foundation
import Moya

///홈프로필 카드 뷰 모델
@MainActor
class HomeProfileCardViewModel: ObservableObject {
    @Published var profileData: HomeProfileData?
    @Published var isChangeCard:  Bool = true
    
    
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
}
