//
//  Pulisher+Moya.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/16/25.
//

import Foundation
import Combine
import Moya

extension Publisher where Failure == MoyaError {
    func validateResult<T>(
        onFailureAction: (() -> Void)? = nil
    ) -> AnyPublisher<T, MoyaError> where Output == ResponseData<T> {
        self.tryMap { response in
            guard response.isSuccess else {
                onFailureAction?()
                throw MoyaError.underlying(APIError.serverError(message: response.message, code: response.code), nil)
            }
            guard let result = response.result else {
                throw MoyaError.underlying(APIError.emptyResult, nil)
            }
            return result
        }
        .mapError { error in
            if let moyaError = error as? MoyaError {
                return moyaError
            } else {
                return MoyaError.underlying(error, nil)
            }
        }
        .eraseToAnyPublisher()
    }
}
