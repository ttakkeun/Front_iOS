//
//  OnboardingViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import Foundation
import Moya

/// 앱 유저 정보 체크 뷰모델
@MainActor
class AppFlowViewModel: ObservableObject {
    private let tokenProvider: TokenProvider = TokenProvider()
    
    @Published var userExistence: Bool = false
    
    /// 리프레시 통한 유저 정보 체크
    /// - Parameter completion: 유저 정보 채크 성공 여부
    public func startAppFlow(completion: @escaping (Bool, Error?) -> Void) async {
        tokenProvider.refreshToken { [weak self] accessToken, error in
            guard self != nil else { return }
            
            if let error = error {
                completion(false, error)
                print("등록된 유저 정보 없음: \(error)")
                return
            }
            
            if accessToken != nil {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}
