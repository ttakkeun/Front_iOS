//
//  QnaView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//
import SwiftUI

struct QnaView: View {
    @State private var selectedSegment: String = "FAQ"
    
    var body: some View {
        VStack(spacing: 0) {
            QnaHeaderView(selectedSegment: $selectedSegment)
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    QnaFAQView()
                        .frame(width: geometry.size.width)
                    QnaTipsView()
                        .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width * 2, alignment: selectedSegment == "FAQ" ? .leading : .trailing)
                .offset(x: selectedSegment == "FAQ" ? 0 : -geometry.size.width)
                .animation(.easeInOut, value: selectedSegment)
            }
        }
    }
}

#Preview {
    QnaView()
}
