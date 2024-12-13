//
//  PetProfileRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

protocol QnARepositoryProtocol {
    func getTipsAll(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func getTipsBest() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func getTips(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func writeTips(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError>
    func patchTipsImage(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError>
}
