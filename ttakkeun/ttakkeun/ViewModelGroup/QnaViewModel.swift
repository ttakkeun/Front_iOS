//
//  QnaViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 7/31/24.
//
import SwiftUI
import Combine

@MainActor
class QnaViewModel: ObservableObject {
    @Published var qnaItems: [CategoryQnAData] = []
    @Published var selectedCategory: CategoryType = .ear
    
    
    //MARK: - init
    init() {
        Task {
            await loadQnAItems()
        }
    }
    
    //MARK: - Function
    public func loadQnAItems() async {
        guard let url = Bundle.main.url(forResource: "CategoryQnaJsonData", withExtension: "json") else {
            print("JSON 파일 찾지 못함")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([CategoryQnAData].self, from: data)
            DispatchQueue.main.async {
                self.qnaItems = items
            }
        } catch {
            print("Json데이터 받아오지 못함: \(error)")
        }
    }
}
