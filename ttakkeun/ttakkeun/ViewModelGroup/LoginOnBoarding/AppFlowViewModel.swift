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
    private let tokenProvider: TokenProvider
    @Published var userExistence: Bool = false
    
    init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    public func startAppFlow(completion: @escaping (Bool, Error?) -> Void) {
        tokenProvider.refreshToken { [weak self] accessToken, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(false, error)
                return
            }
            
            if let accessToken = accessToken {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}
