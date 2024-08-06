//
//  QnaTipsView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/5/24.
//
import SwiftUI

/// Qna탭중 Tips에 대한 뷰
struct QnaTipsView: View {
    var body: some View {
        VStack {
            /*TipsView 만들자*/
        }
    }
}

//MARK: - Preview
struct QnaTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaTipsView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
