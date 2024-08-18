//
//  QnaView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//

import SwiftUI

/// Qna탭에 들어갈 View집합
struct QnaView: View {
    @StateObject private var faqViewModel = QnaViewModel()
    @StateObject private var tipsViewModel = QnaTipsViewModel()
    @State private var selectedSegment: String = "FAQ"
    @State private var isFloatingBtnPresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                QnaHeaderView(selectedSegment: $selectedSegment)
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        QnaFAQView(viewModel: faqViewModel)
                            .frame(width: geometry.size.width)
                        QnaTipsView(viewModel: tipsViewModel)
                            .frame(width: geometry.size.width)
                    }
                    .frame(width: geometry.size.width * 2, alignment: selectedSegment == "FAQ" ? .leading : .trailing)
                    .offset(x: selectedSegment == "FAQ" ? 0 : -geometry.size.width)
                    .animation(.easeInOut, value: selectedSegment)
                }
            }
            .zIndex(1)

            if selectedSegment == "TIPS" {
                if isFloatingBtnPresented {
                    Color.btnBackground.opacity(0.6)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isFloatingBtnPresented = false
                            }
                        }
                }

                FloatingWriteBtn(isPresented: $isFloatingBtnPresented)
                    .zIndex(2)
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
