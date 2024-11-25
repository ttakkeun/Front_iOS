//
//  SaerchViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var isSearchActive: Bool = false
    
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    @Published var searchText: String = ""
    @Published var realTimeSearchResult: [ProductResponse]?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.realTimeSearchResult = nil
                    return
                }
                self?.fetchSearchResults(for: query)
            }
            .store(in: &cancellables)
    }
    
    
    func fetchSearchResults(for query: String) {
        print(searchText)
    }
    
    func saveSearchTerm(_ query: String) {
        guard !query.isEmpty else { return }
        
        if !self.recentSearches.contains(query) {
            self.recentSearches.insert(query, at: 0)
            if self.recentSearches.count > 25 {
                self.recentSearches.removeLast()
            }
        }
        
        UserDefaults.standard.set(self.recentSearches, forKey: "RecentSearches")
    }
    
    func deleteSearch(_ text: String) {
        if let index = self.recentSearches.firstIndex(of: text) {
            self.recentSearches.remove(at: index)
            UserDefaults.standard.set(self.recentSearches, forKey: "RecentSearches")
        }
    }

    
}
