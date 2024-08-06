//
//  QnaHeaderView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/6/24.
//

import SwiftUI

/// Qna탭에 있는 헤더 - 세그먼티드 컨트롤로 QnaFAQView와 QnaFAQView 번갈아가며 볼 수 있음
struct QnaHeaderView: View {

    let segments: [String] = ["FAQ", "TIPS"]
    @State private var selected: String = "FAQ"
    @Namespace var name

    //MARK: - Contents
    var body: some View {
           VStack(spacing: 0) {
               header
               // FAQ뷰와 TIPS뷰 전환하는 코드
               GeometryReader { geometry in
                   HStack(spacing: 0) {
                       QnaFAQView()
                           .frame(width: geometry.size.width)
                       QnaTipsView()
                           .frame(width: geometry.size.width)
                   }
                   .frame(width: geometry.size.width * 2, alignment: selected == "FAQ" ? .leading : .trailing)
                   .offset(x: selected == "FAQ" ? 0 : -geometry.size.width)
                   .animation(.easeInOut, value: selected)
               }
           }
       }
    
    /// StatusBar랑 FAQ,TIPS segmentedControl 모은 최상단 Header
    private var header: some View {
        VStack(alignment: .leading) {
            TopStatusBar()
            Spacer()
            customSegmentedControl
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.mainBg)
        .overlay(
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundColor(Color.gray200),
            alignment: .bottom)
    }
    
    /// FAQ, TIPS segmented Control
    private var customSegmentedControl: some View {
        HStack(spacing: 0){
            ForEach(segments, id: \.self) { segment in
                Button {
                    withAnimation{
                        selected = segment
                    }
                } label: {
                    VStack(spacing: 6) {
                        if selected == segment {
                            Text(segment)
                                .font(.Body2_bold)
                                .foregroundColor(.gray900)
                        } else {
                            Text(segment)
                                .font(.Body2_regular)
                                .foregroundColor(.gray900)
                        }
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(width: 46, height: 3)
                            if selected == segment {
                                Capsule()
                                    .fill(Color.gray600)
                                    .frame(width: 46, height: 3)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Preview
struct QnaHeaderView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaHeaderView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
