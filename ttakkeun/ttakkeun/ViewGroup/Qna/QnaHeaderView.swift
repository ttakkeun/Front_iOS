//
//  QnaHeaderView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/6/24.
//

import SwiftUI

/// QnaTab 최상단에 있을 header
struct QnaHeaderView: View {
    @Binding var selectedSegment: String
    
    let segments: [String] = ["FAQ", "TIPS"]
    @Namespace var name

    var body: some View {
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
    
    /// Tips와 Faq 이동시켜주는 세그먼티드 컨트롤
    private var customSegmentedControl: some View {
        HStack(spacing: 0){
            ForEach(segments, id: \.self) { segment in
                Button {
                    withAnimation{
                        selectedSegment = segment
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(segment)
                            .font(selectedSegment == segment ? .Body2_bold : .Body2_regular)
                            .foregroundColor(.gray900)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(width: 46, height: 3)
                            if selectedSegment == segment {
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
    
    static let devices = ["iPhone 11", "iPhone 15 Pro", "iPhone 15 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
