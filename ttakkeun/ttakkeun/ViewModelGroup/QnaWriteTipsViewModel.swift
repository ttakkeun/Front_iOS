//
//  QnaWriteTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/11/24.
//

import Foundation
import SwiftUI
import Moya

@MainActor
class QnaWriteTipsViewModel: ObservableObject {
    @Published var requsetData: QnaTipsData? =
    QnaTipsData(category: .ear, title: "", content: "", userName: "", elapsedTime: 1)
    @Published var responseData: QnaTipsData?
    @Published var isTipsinputCompleted: Bool = false
    
    private let provider: MoyaProvider<QnaTipsAPITarget>
   
    init(isTipsinputCompleted: Bool = false ,
         provider:
         MoyaProvider<QnaTipsAPITarget> =
         APIManager.shared.testProvider(for: QnaTipsAPITarget.self)
    ) {
        self.isTipsinputCompleted = isTipsinputCompleted
        self.provider = provider
    }
    
    
    @Published var Title: Bool = false {
        didSet { checkFilledStates() }
    }
    @Published var Content: Bool = false {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isTipsinputCompleted = Title && Content
    }
    
    
    //MARK: - AppendImage Function
    
}
