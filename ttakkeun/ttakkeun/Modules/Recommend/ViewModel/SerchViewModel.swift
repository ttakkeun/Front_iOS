//
//  SaerchViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject, TapGestureProduct, ProductUpdate {
    
    @Published var isShowingSearchResult: Bool = false
    @Published var isShowingRealTimeResults: Bool = false
    @Published var isManualSearch: Bool = false
    
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    
    @Published var searchText: String = ""
    @Published var realTimeSearchResult: [ProductResponse]?
    
    @Published var naverDataIsLoading: Bool = true
    @Published var naverData: [ProductResponse] = []
    
    @Published var isIitialLoading: Bool = true
    @Published var localDBDataIsLoading: Bool = false
    @Published var localDbData: [ProductResponse] = []
    @Published var localPage: Int = 0
    @Published var canLoadMore: Bool = true
    
    // MARK: - ProductSheet
    
    @Published var isShowSheetView: Bool = false
    @Published var isLoadingSheetView: Bool = false
    @Published var selectedData: ProductResponse? = nil
    @Published var selectedSource: RecommendProductType = .none
    
    func handleTap(data: ProductResponse, source: RecommendProductType) {
        self.selectedData = data
        self.selectedSource = source
        self.isLoadingSheetView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.isLoadingSheetView.toggle()
            self.isShowSheetView.toggle()
        })
    }
    
    func updateProduct(_ updateProduct: ProductResponse) {
        switch self.selectedSource {
        case .searchNaverProduct:
            if let index = naverData.firstIndex(where: { $0.id == updateProduct.id }) {
                naverData[index] = updateProduct
            }
        case .searchLocalProduct:
            if let index = localDbData.firstIndex(where: { $0.id == updateProduct.id }) {
                localDbData[index] = updateProduct
            }
        default:
            break
        }
    }
    
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        
        self.container = container
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
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
    
    
    public func goToSearchView() {
        
    }
}

extension SearchViewModel {
    
    func fetchRealTimeResults(for query: String) {
        isShowingRealTimeResults = true
        print("실시간 검색 데이터 받아옴: \(query)")
        searchNaver(isRealTime: true, keyword: query)
    }
    
    func fetchSearchResults(for query: String) {
        self.isShowingSearchResult = true
        print("검색 결과 받아옴: \(query)")
        self.searchText = query
        searchNaver(isRealTime: false, keyword: query)
        startNewLocalDbSearch(query)
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

extension SearchViewModel {
    private func searchNaver(isRealTime: Bool, keyword: String) {
        naverDataIsLoading = true
        
        container.useCaseProvider.searchUseCase.executeSearchNaver(keyword: keyword)
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ SearchNaver Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("✅ SearchNaver Product Server Completed")
                    
                case .failure(let failure):
                    if isRealTime {
                        self.realTimeSearchResult = nil
                    } else {
                        self.naverData = []
                    }
                    print("❌ SearchNaver Product Server Failure \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                print("🔵 SearchNaver Product Data: \(responseData)")
                if let data = responseData.result {
                    if isRealTime {
                        self.realTimeSearchResult = data
                    } else {
                        self.naverData = data
                        naverDataIsLoading = false
                    }
                } else {
                    if isRealTime {
                        self.realTimeSearchResult = nil
                    } else {
                        self.naverData = []
                        naverDataIsLoading = false
                        naverDataIsLoading = false
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    public func searchLocalDb(keyword: String, page: Int) {
        guard !localDBDataIsLoading && canLoadMore else { return }
        
        localDBDataIsLoading = true
        
        container.useCaseProvider.searchUseCase.executeSearchLocalDB(keyword: keyword, page: page)
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ searchLocalDb Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                localDBDataIsLoading = false
                
                switch completion {
                case .finished:
                    print("✅ localDB Product Server Completed")
                case .failure(let failure):
                    print("❌ localDB Product Server Failure \(failure)")
                    canLoadMore = false
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let data = responseData.result {
                    if !data.isEmpty {
                        self.localDbData.append(contentsOf: data)
                        self.localPage += 1
                        self.canLoadMore = true
                    }
                } else {
                    self.canLoadMore = false
                }
                
                self.isIitialLoading = false
            })
            .store(in: &cancellables)
    }
    
    func startNewLocalDbSearch(_ keyword: String) {
        self.searchText = keyword
        self.localPage = 0
        self.canLoadMore = true
        self.localDbData = []
        self.isIitialLoading = true
        searchLocalDb(keyword: searchText, page: localPage)
    }
}
