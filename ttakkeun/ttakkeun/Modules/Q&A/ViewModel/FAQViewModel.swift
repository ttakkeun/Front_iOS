//
//  FAQViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation
import Combine

class FAQViewModel: ObservableObject {
    @Published var selectedCategory: PartItem = .ear
    @Published var topTenQuestions: [FAQData] = []
    @Published var listItem: [FAQData] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadToptenQnAItems()
            .combineLatest(loadCategoryQnAItems())
            .sink { [weak self] topTen, categoryItem in
                self?.topTenQuestions = Array(topTen.prefix(10))
                self?.listItem = categoryItem
            }
            .store(in: &cancellables)
    }
    
    
    private func loadToptenQnAItems() -> AnyPublisher<[FAQData], Never> {
        Future { promise in
            guard let url = Bundle.main.url(forResource: "TopTenQnaJsonData", withExtension: "json") else {
                print("TOp10 JSON 파일 찾지 못 했습니다.")
                promise(.success([]))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let items = try decoder.decode([FAQData].self, from: data)
                promise(.success(items))
            } catch {
                print("JSON데이터 받아오기 실패: \(error)")
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loadCategoryQnAItems() -> AnyPublisher<[FAQData], Never> {
           Future { promise in
               guard let url = Bundle.main.url(forResource: "CategoryQnaJsonData", withExtension: "json") else {
                   print("JSON 파일 찾지 못함")
                   promise(.success([]))
                   return
               }
               
               do {
                   let data = try Data(contentsOf: url)
                   let decoder = JSONDecoder()
                   let items = try decoder.decode([FAQData].self, from: data)
                   promise(.success(items))
               } catch {
                   print("Json데이터 받아오지 못함: \(error)")
                   promise(.success([]))
               }
           }
           .eraseToAnyPublisher()
       }
    
    public var filteredCategoryItems: [FAQData] {
        return listItem.filter { $0.category == selectedCategory }
    }
}
