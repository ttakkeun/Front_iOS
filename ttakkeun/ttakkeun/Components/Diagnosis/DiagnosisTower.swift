//
//  DiagnosisTower.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/21/24.
//

import SwiftUI

/// 진단 결과 내부 뼈 타워 컴포넌트
struct DiagnosisTower: View {
    
    let data: Diagnosis
    
    init(data: Diagnosis) {
        self.data = data
    }
    
    var body: some View {
        ZStack {
            self.towerImage()
            
            HStack {
                self.contentsText(dateFormatter)
                
                Spacer()
                
                self.contentsText(timeFormatter)
            }
            .frame(maxWidth: 165)
        }
    }

    
    // MARK: - Contents
    
    private var dateFormatter: String {
        let dateString = ISO8601DateFormatter()
        
        if let date = dateString.date(from: data.createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.MM.dd"
            let datePart = dateFormatter.string(from: date)
            return datePart
        } else {
            return "Invalid Date"
        }
    }
    
    private var timeFormatter: String {
        let timeString = ISO8601DateFormatter()
        
        if let time = timeString.date(from: data.createdAt) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let timePart = timeFormatter.string(from: time)
            return timePart
        } else {
            return "Invalid Time"
        }
    }
    
    // MARK: - Function
    
    /// 점수에 따라 등장하는 뼈 타워
    /// - Returns: 점수에 해당하는 뼈 타워, 내림차순으로 색이 연해진다.
    private func towerImage() -> Image {
        switch data.score {
        case 0...20:
            return Icon.top5.image
        case 20...40:
            return Icon.top4.image
        case 40...60:
            return Icon.top3.image
        case 60...80:
            return Icon.top2.image
        case 80...100:
            return Icon.top1.image
        default:
            return Icon.top1.image
        }
    }
    
    private func contentsText(_ date: String) -> Text {
        Text(date)
            .font(.Body2_medium)
            .foregroundStyle(Color.gray_900)
    }
}

struct DiagnosisTower_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisTower(data: Diagnosis.init(diagID: 1, createdAt: "2024-07-20T15:30:00+09:00", score: 100))
            .previewLayout(.sizeThatFits)
    }
}
