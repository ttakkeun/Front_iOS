//
//  TipsViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation
import Combine

class TipsViewModel: ObservableObject {
    @Published var isSelectedCategory: ExtendPartItem = .all
    @Published var tipsResponse: [TipsResponse] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func toggleLike(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isLike.toggle()
            
            sendLikeStatusToServer(tipID: tipID, isLiked: tipsResponse[index].isLike)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error updating like status: \(error)")
                        self.tipsResponse[index].isLike.toggle()
                    }
                } receiveValue: { success in
                    print("Successfully updated like status for \(tipID): \(success)")
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleBookMark(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isScrap.toggle()
            
            sendBookMarkStatusToServer(tipID: tipID, isScrap: tipsResponse[index].isScrap)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error updating like status: \(error)")
                        self.tipsResponse[index].isScrap.toggle()
                    }
                } receiveValue: { success in
                    print("Successfully updated like status for \(tipID): \(success)")
                }
                .store(in: &cancellables)
        }
    }
    
    private func sendLikeStatusToServer(tipID: Int, isLiked: Bool) -> AnyPublisher<Bool, Error> {
        // 서버 요청 시뮬레이션
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success(true)) // 성공 시 true 반환
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func sendBookMarkStatusToServer(tipID: Int, isScrap: Bool) -> AnyPublisher<Bool, Error> {
        // 서버 요청 시뮬레이션
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success(true)) // 성공 시 true 반환
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
