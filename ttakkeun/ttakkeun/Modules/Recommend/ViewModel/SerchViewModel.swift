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
    @Published var isShowingSearchResult: Bool = false
    @Published var isShowingRealTimeResults: Bool = false
    @Published var isManualSearch: Bool = false
    
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    
    @Published var searchText: String = ""
    @Published var realTimeSearchResult: [ProductResponse]?
    
    @Published var naverData: [ProductResponse] = []
    @Published var localDbData: [ProductResponse] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                
                if self.isManualSearch {
                    self.fetchSearchResults(for: newValue)
                    self.isManualSearch = false
                    return
                } else {
                    if newValue.isEmpty {
                        self.realTimeSearchResult = nil
                    } else {
                        self.fetchRealTimeResults(for: newValue)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchRealTimeResults(for query: String) {
        isShowingRealTimeResults = true
        print("실시간 검색 데이터 받아옴: \(query)")
    }
    
    func fetchSearchResults(for query: String) {
        self.isShowingSearchResult = true
        print("검색 결과 받아옴: \(query)")
        self.searchText = query
    }
    
    func handleSearchTextChange(_ newValue: String, _ oldValue: String) {
        if newValue.isEmpty {
            self.isShowingSearchResult = false
            self.isShowingRealTimeResults = false
        } else if oldValue.isEmpty {
            self.isShowingRealTimeResults = false
            self.isShowingSearchResult = false
        } else {
            self.isShowingSearchResult = false
            self.isShowingRealTimeResults = true
            self.fetchRealTimeResults(for: newValue)
        }
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
