//
//  WeekBar.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/15/24.
//


import SwiftUI
import Kingfisher

/// 달력 주차 표시하는 막대
struct WeekBar: View {
    
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat = 31) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.primarycolor_100)
            .frame(width: width, height: height)
    }
}

#Preview {
    WeekBar(width: 300)
}
