//
//  RecommendationViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation

class RecommendationViewModel: ObservableObject {
    @Published var selectedCategory: ExtendPartItem = .all
    @Published var aiProducts: [ProductResponse]? = [ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: nil, likeStatus: false)]
    @Published var recommendProducts: [ProductResponse] = [
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 9992, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 999, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 11, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 12, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 0, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 0, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 0, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 0, likeStatus: false),
        ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 0, likeStatus: false)
    ]
    @Published var searchText: String = ""
    
}
