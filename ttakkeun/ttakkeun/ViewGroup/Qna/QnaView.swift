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
            faqAndTipsSegmentSet
            .zIndex(1)
            //Tips면 floatingBtn나오도록
            if selectedSegment == "TIPS" {
                if isFloatingBtnPresented {
                    Color.clear
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
    
    /// faq랑 tips 뷰 전환할 수 있도록 함.
    private var faqAndTipsSegmentSet: some View {
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
