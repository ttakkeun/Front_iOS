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
    @Published var qnaItems: [QnaFaqData] = []
    @Published var topTenQuestions: [QnaFaqData] = []
    @Published var selectedCategory: CategoryType = .ear
    
    
    //MARK: - init
    init() {
        Task {
            await loadToptenQnAItems()
            await loadCategoryQnAItems()
        }
    }
    
    //MARK: - Function
  
    public func loadToptenQnAItems() async {
           guard let url = Bundle.main.url(forResource: "TopTenQnaJsonData", withExtension: "json") else {
               print("JSON 파일 찾지 못함")
               return
           }

           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let items = try decoder.decode([QnaFaqData].self, from: data)
               DispatchQueue.main.async {
                   self.qnaItems = items
                   self.topTenQuestions = Array(items.prefix(10))
               }
           } catch {
               print("Json데이터 받아오지 못함: \(error)")
           }
       }
    
    public func loadCategoryQnAItems() async {
        guard let url = Bundle.main.url(forResource: "CategoryQnaJsonData", withExtension: "json") else {
            print("JSON 파일 찾지 못함")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([QnaFaqData].self, from: data)
            DispatchQueue.main.async {
                self.qnaItems = items
            }
        } catch {
            print("Json데이터 받아오지 못함: \(error)")
        }
    }
    
}
