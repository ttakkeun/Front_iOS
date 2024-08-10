//
//  JournalListCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import SwiftUI

/// 조회된 일지 목록 카드
struct JournalListCard: View {
    
    let data: JournalRecord
    let part: PartItem
    
    // MARK: - Init
    
    /// 카테고리 항목에 대한 일지 데이터 조회 카드
    /// - Parameter data: 일지 데이터 값
    init(
        data: JournalRecord,
        part: PartItem
    ) {
        self.data = data
        self.part = part
    }
    
    // MARK: - Contents
    
    var body: some View {
        ZStack(alignment: .top, content: {
            journalListCard
            topPostit
        })
    }
    
    /// 일지 데이터 개별 카드
    private var journalListCard: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white)
                .frame(width: 95, height: 95)
                .shadow03()
          
            VStack(alignment: .leading, content: {
                Text("\(formattedDate.prefix(4)) \n\(formattedDate.dropFirst(5))")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray_900)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                
                Spacer()
                
                Text(formattedTime)
                    .font(.Body5_medium)
                    .foregroundStyle(Color.gray_500)
                    .padding(.leading, 50)
            })
            .frame(width: 74, height: 70)
        })
        .padding(.top, 6)
    }
    
    /// 일지 상단 포스트잇 스티커
    private var topPostit: some View {
        Rectangle()
            .fill(stickerColor())
            .frame(width: 49, height: 13)
            .shadow02()
    }
    
    // MARK: - TextFormatter
    /// 시간 데이터 파
    private var formattedTime: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        guard let date = inputFormatter.date(from: data.recordTime) else {
            return data.recordTime
        }
        return outputFormatter.string(from: date)
    }
    
    /// 날짜 데이터 파싱
    private var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let date = inputFormatter.date(from: data.recordDate) else {
            return data.recordDate
        }
        
        return outputFormatter.string(from: date)
    }
    
    // MARK: - Function
    
    /// 스티커 배경 백그라운드 컬러
    /// - Parameter part: 카테고리 항목
    /// - Returns: 카테고리별 Color 지정
    private func stickerColor() -> Color {
        switch part {
        case .ear:
            Color.beforeEar_Color
        case .eye:
            Color.beforeEye_Color
        case .hair:
            Color.beforeHair_COlor
        case .claw:
            Color.beforeClaw_Color
        case .tooth:
            Color.beforeTeeth_Color
        }
    }
}

struct JournalListCard_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            JournalListCard(data: JournalRecord(recordID: 1, recordDate: "2024-12-31", recordTime: "15:22:10"), part: .hair)
                .previewDisplayName(device)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewLayout(.sizeThatFits)
        }
    }
}
