//
//  AccessTokenRefresher.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import Moya
import Alamofire

class AccessTokenRefresher: RequestInterceptor {
    private var tokenProvider: TokenProviding
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    init(tokenProvider: TokenProviding) {
        self.tokenProvider = tokenProvider
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = tokenProvider.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < 1, let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetry)
        }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            isRefreshing = true
            tokenProvider.refreshToken { [weak self] newToken, error in
                guard let self = self else { return }
                self.isRefreshing = false
                let result = error == nil ? RetryResult.retry : RetryResult.doNotRetryWithError(error!)
                self.requestsToRetry.forEach{ $0(result) }
                self.requestsToRetry.removeAll()
            }
        }
    }
}
