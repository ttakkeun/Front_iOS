//
//  HomeNotTodoList.swift
//  ttakkeun
//
//  Created by 한지강 on 7/15/24.
//

import SwiftUI

/// Init으로 원에 사진과 색 넣을 수 있도록 함
struct HomeNotTodoCircle: View {
    var color: Color
    var icon: Image
    
    init(color: Color, icon: Image) {
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
            icon
                .fixedSize()
        }
    }
}
