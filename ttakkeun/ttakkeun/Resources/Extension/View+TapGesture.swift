//
//  TapGesture.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import SwiftUI

extension View {
    func handleTapGesture<T: TapGestureProduct>(with viewModel: T, data: ProductResponse, source: RecommendProductType) -> some View {
        self.onTapGesture {
            viewModel.handleTap(data: data, source: source)
        }
    }
}
