//
//  JournalListCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

struct JournalListCard: View {
    
    let cardData: JournalListCardData
    @Binding var isSelected: Bool
    
    init(cardData: JournalListCardData, isSelected: Binding<Bool>) {
        self.cardData = cardData
        self._isSelected = isSelected
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            bottomPostit
                .padding(.top, 8)
            topPostit
            
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray600)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(.top, 75)
                    .padding(.leading, 65)
            }
        })
    }
    
    private var bottomPostit: some View {
        VStack(spacing: 24, content: {
            
            HStack(content: {
                Text("\(DataFormatter.shared.formattedDate(from: cardData.data.recordDate).prefix(4)) \n\(DataFormatter.shared.formattedDate(from: cardData.data.recordDate).dropFirst(5))")
                    .font(.Body4_medium)
                    .foregroundStyle(isSelected ? Color.gray200 : Color.gray900)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                
                Spacer()
            })
            .frame(alignment: .leading)
            
            HStack(content: {
                Spacer()
                
                Text(DataFormatter.shared.formattedTime(from: cardData.data.recordTime))
                    .font(.Body5_medium)
                    .foregroundStyle(isSelected ? Color.gray200 : Color.gray900)
            })
            .frame(alignment: .trailing)
        })
        .frame(width: 74, height: 70)
        .padding(.top, 16)
        .padding(.leading, 10)
        .padding(.trailing, 11)
        .padding(.bottom, 9)
        .background {
            Rectangle()
                .fill(Color.white)
                .shadow03()
        }
    }
    
    private var topPostit: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(cardData.part.toColor())
            .frame(width: 49, height: 14)
            .shadow02()
    }
}

struct JournalListCardData {
    let data: JournalListItem
    let part: PartItem
}

struct JournalListCard_Preview: PreviewProvider {
    static var previews: some View {
        JournalListCard(cardData: JournalListCardData(data: JournalListItem(recordID: 0, recordDate: "2024-11-09", recordTime: "14:58:11.123"), part: .ear), isSelected: .constant(true))
    }
}
