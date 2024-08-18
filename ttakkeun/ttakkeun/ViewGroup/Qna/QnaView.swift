//
//  QnaView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//

import SwiftUI

struct QnaView: View {
    @StateObject private var faqViewModel = QnaViewModel()
    @StateObject private var tipsViewModel = QnaTipsViewModel(tip_id: 0)
    
    @State private var selectedSegment: String = "FAQ"
    
    var body: some View {
        VStack(spacing: 0) {
            QnaHeaderView(selectedSegment: $selectedSegment)
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if selectedSegment == "FAQ" {
                        QnaFAQView(viewModel: faqViewModel)
                            .frame(width: geometry.size.width)
                            .id(faqViewModel)
                    } else if selectedSegment == "TIPS" {
                        QnaTipsView(viewModel: tipsViewModel)
                            .frame(width: geometry.size.width)
                            .id(tipsViewModel) 
                    }
                }
                .frame(width: geometry.size.width * 2, alignment: selectedSegment == "FAQ" ? .leading : .trailing)
                .offset(x: selectedSegment == "FAQ" ? 0 : -geometry.size.width)
                .animation(.easeInOut, value: selectedSegment)
            }
        }
    }
}


//MARK: - Preview
struct QnaView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro", "iPhone 15 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
