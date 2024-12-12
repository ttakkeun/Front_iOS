//
//  TapGestureProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation

protocol TapGestureProduct: AnyObject {
    var isShowSheetView: Bool { get set }
    var selectedData: ProductResponse? { get set }
    var selectedSource: RecommendProductType { get set }
    
    func handleTap(data: ProductResponse, source: RecommendProductType)
}
