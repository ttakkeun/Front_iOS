//
//  DiagnosisTower.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/18/24.
//

import SwiftUI

struct DiagnosisTower: View {
    
    let data: diagDetailData
    let onTap: () -> Void // 클릭 이벤트
    
    init(data: diagDetailData, onTap: @escaping () -> Void) {
        self.data = data
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            towerImage()
            
            HStack {
                
                contentsText(DataFormatter.shared.convertToKoreanTime(from: data.created_at))
                
                Spacer()
                
                contentsText(timeFormatter)
            }
            .frame(maxWidth: 165)
        }
        .onTapGesture {
            onTap() // 클릭 시 부모 뷰에 이벤트 전달
        }
    }
    
    private func contentsText(_ date: String) -> some View {
        ZStack {
            Text(date)
                .font(.Body2_medium)
                .foregroundColor(.clear) // 안쪽 색상 제거
                .overlay(
                    Text(date)
                        .font(.Body2_medium)
                        .foregroundColor(.black) // 외곽선 색상
                        .offset(x: 0, y: 0) // 중앙에 겹침
                        .blur(radius: 0.5) // 외곽선이 부드럽게
                )
            
            Text(date)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white) // 내부 색상
        }
    }
    
    private func towerImage() -> Image {
        switch data.score {
        case 0...20:
            return Icon.bones1.image
        case 20...40:
            return Icon.bones2.image
        case 40...60:
            return Icon.bones3.image
        case 60...80:
            return Icon.bones4.image
        case 80...100:
            return Icon.bones5.image
        default:
            return Icon.bones1.image
        }
    }
    
    private var timeFormatter: String {
        let timeString = ISO8601DateFormatter()
        
        if let time = timeString.date(from: data.created_at) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let timePart = timeFormatter.string(from: time)
            return timePart
        } else {
            return "Invalid Time"
        }
    }
}
