//
//  SaerchViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import Foundation
import Combine

@Observable
class SearchViewModel: TapGestureProduct, ProductUpdate {
    // MARK: - StateProperty
    var isShowingSearchResult: Bool = true
    var isShowingRealTimeResults: Bool = false
    var isManualSearch: Bool = false
    var isFirstAppear: Bool = false
    var naverDataIsLoading: Bool = false
    var localDBDataIsLoading: Bool = false
    
    var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    
    var searchText: String = "" {
        didSet {
            handleSearchTextChange()
        }
    }
    var realTimeSearchResult: [ProductResponse] = []
    
    var naverData: [ProductResponse] = []
    var localDbData: [ProductResponse] = []
    var localPage: Int = 0
    var canLoadMore: Bool = true
    
    // MARK: - ProductShee
    var selectedData: ProductResponse? = nil
    var selectedSource: RecommendProductType = .none
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    private var debounceTask: Task<Void, Never>? = nil
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    private func handleSearchTextChange() {
        debounceTask?.cancel()
        
        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if isManualSearch {
                fetchSearchResults(for: searchText)
                isManualSearch = false
            } else {
                if searchText.isEmpty {
                    realTimeSearchResult = []
                } else {
                    fetchRealTimeResults(for: searchText)
                }
            }
        }
    }
    
    func makeLikePatchRequest(data: ProductResponse) -> ProductLikeRequest {
        return .init(
            title: data.title,
            image: data.image,
            price: data.price,
            brand: data.brand ?? "",
            link: data.purchaseLink,
            category1: data.category1 ?? "",
            category2: data.category2 ?? "",
            category3: data.category3 ?? "",
            category4: data.category4 ?? ""
        )
    }
    
    func handleTap(data: ProductResponse, source: RecommendProductType) {
        self.selectedData = data
        self.selectedSource = source
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
    
    func fetchRealTimeResults(for query: String) {
        isShowingRealTimeResults = true
        searchNaver(isRealTime: true, keyword: query)
        
#if DEBUG
        print("실시간 검색 데이터 받아옴: \(query)")
#endif
    }
    
    func fetchSearchResults(for query: String) {
        self.isShowingSearchResult = true
        self.searchText = query
        searchNaver(isRealTime: false, keyword: query)
        startNewLocalDbSearch(query)
        
#if DEBUG
        print("검색 결과 받아옴: \(query)")
#endif
    }
    
    func startNewLocalDbSearch(_ keyword: String) {
        self.searchText = keyword
        self.localPage = 0
        self.canLoadMore = true
        self.localDbData = []
        searchLocalDb(keyword: searchText, page: localPage)
    }
    
    func handleSearchTextChange(_ oldValue: String, _ newValue: String) {
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
    
    // MARK: - SearchNaver
    /// 네이버 검색
    /// - Parameters:
    ///   - isRealTime: 실시간 여부
    ///   - keyword: 키워드
    private func searchNaver(isRealTime: Bool, keyword: String) {
        naverDataIsLoading = true
        
        container.useCaseProvider.productUseCase.executeGetSearchNaver(keyword: keyword)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("SearchNaver Product Server Completed")
                    
                case .failure(let failure):
                    if isRealTime {
                        self.realTimeSearchResult = []
                    } else {
                        self.naverData = []
                    }
                    print("SearchNaver Product Server Failure \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if !responseData.isEmpty {
                    if isRealTime {
                        self.realTimeSearchResult = responseData
                    } else {
                        self.naverData = responseData
                        naverDataIsLoading = false
                    }
                } else {
                    if isRealTime {
                        self.realTimeSearchResult = []
                    } else {
                        self.naverData = []
                        naverDataIsLoading = false
                    }
                }
                print("SearchNaver Product Data: \(responseData)")
            })
            .store(in: &cancellables)
    }
    
    // MARK: - LocalSearch
    public func searchLocalDb(keyword: String, page: Int) {
        guard !localDBDataIsLoading && canLoadMore else { return }
        localDBDataIsLoading = true
        
        container.useCaseProvider.productUseCase.executeGetSearchLocal(keyword: keyword, page: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.localDBDataIsLoading = false }
                
                switch completion {
                case .finished:
                    print("localDB Product Server Completed")
                case .failure(let failure):
                    print("localDB Product Server Failure \(failure)")
                    canLoadMore = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if !responseData.isEmpty {
                    self.localDbData.append(contentsOf: responseData)
                    self.localPage += 1
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Like
    func likeProduct(productId: Int, productData: ProductLikeRequest) {
        container.useCaseProvider.productUseCase.executePutLikeProductData(productId: productId, likeData: productData)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("ProductLike Server Completed")
                case .failure(let failure):
                    print("ProductLike Server Failure \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("ProductLike: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}
