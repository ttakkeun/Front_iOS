//
//  JournalListCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 일지 목록 데이터 카드
struct JournalListCard: View {
    
    // MARK: - Property
    let cardData: JournalListCardData
    @Binding var isSelected: Bool
    
    // MARK: - Constant
    fileprivate enum JournalListCardConstants {
        static let bottomAreaHorizonPadding: CGFloat = 10
        static let bottomAreaBottomPadding: CGFloat = 9
        static let bottomAreaToPadding: CGFloat = 16
        static let dateVspacing: CGFloat = 3
        
        static let datePrefix: Int = 4
        static let dropCount: Int = 5
        
        static let postitRadius: CGFloat = 4
        static let postitWidth: CGFloat = 49
        static let postitHeight: CGFloat = 14
        static let postitBottomPadding: CGFloat = 8
        
        static let checkTopPadding: CGFloat = 75
        static let checkLeadingPadding: CGFloat = 65
        static let listCardMinHeight: CGFloat = 101
        
        static let checkSize: CGFloat = 18
        static let checkIconText: String = "checkmark.circle"
    }
    
    // MARK: - Init
    init(cardData: JournalListCardData, isSelected: Binding<Bool>) {
        self.cardData = cardData
        self._isSelected = isSelected
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top, content: {
            topArea
            topPostit
            
            if isSelected {
                bottomCheck
            }
        })
    }
    
    // MARK: - TopArea
    private var topArea: some View {
        VStack(alignment: .leading, content: {
            topDateInfo
            Spacer()
            createTimeInfo
        })
        .padding(.horizontal, JournalListCardConstants.bottomAreaHorizonPadding)
        .padding(.top, JournalListCardConstants.bottomAreaToPadding)
        .padding(.bottom, JournalListCardConstants.bottomAreaBottomPadding)
        .background {
            Rectangle()
                .fill(Color.white)
                .shadow03()
        }
        .frame(minHeight: JournalListCardConstants.listCardMinHeight)
    }
    
    /// 상단 날짜 데이터
    private var topDateInfo: some View {
        VStack(alignment: .leading, spacing: JournalListCardConstants.dateVspacing, content: {
            Text(cardData.data.recordDate.formattedDate().prefix(JournalListCardConstants.datePrefix))
            Text(cardData.data.recordDate.formattedDate().dropFirst(JournalListCardConstants.dropCount))
        })
        .font(.Body4_medium)
        .foregroundStyle(isSelected ? Color.gray200 : Color.gray900)
        .multilineTextAlignment(.center)
    }
    
    ///  하단 시간 데이터
    private var createTimeInfo: some View {
        HStack {
            Spacer()
            
            Text(cardData.data.recordTime.formattedDate())
                .font(.Body5_medium)
                .foregroundStyle(isSelected ? Color.gray200 : Color.gray900)
        }
    }
    
    /// 상단 포스트잇
    private var topPostit: some View {
        RoundedRectangle(cornerRadius: JournalListCardConstants.postitRadius)
            .fill(cardData.part.toColor())
            .frame(width: JournalListCardConstants.postitWidth, height: JournalListCardConstants.postitHeight)
            .shadow02()
            .offset(y: -JournalListCardConstants.postitBottomPadding)
    }
    
    // MARK: - BottomCheck
    private var bottomCheck: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: JournalListCardConstants.checkIconText)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray600)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: JournalListCardConstants.checkSize, height: JournalListCardConstants.checkSize)
                    .padding(.top, JournalListCardConstants.checkTopPadding)
                    .padding(.leading, JournalListCardConstants.checkLeadingPadding)
            }
        }
    }
}

struct JournalListCard_Preview: PreviewProvider {
    static var previews: some View {
        JournalListCard(cardData: JournalListCardData(data: JournalListItem(recordID: 0, recordDate: "2024-11-09", recordTime: "14:58:11.123"), part: .ear), isSelected: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
