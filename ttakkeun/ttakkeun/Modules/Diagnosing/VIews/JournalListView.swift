//
//  JournalListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

struct JournalListView: View {
    var body: some View {
        EmptyJournalList
    }
    
    private var makeJournalList: some View {
        Button(action: {
            //TODO: - DIContainer 네비게이션 이동
        }, label: {
            
            ZStack {
                Circle()
                    .fill(Color.mainPrimary)
                    .frame(width: 67, height: 67)
                
                Icon.pen.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 27)
            }
        })
    }
    
    private var EmptyJournalList: some View {
        VStack(spacing:19, content: {
            
            Spacer()
            
            Icon.noJournal.image
                .fixedSize()
            
            Text("일지가 아직 없네요! \n오늘의 반려동물 일지를 작성해보세요!")
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
            
            Spacer()
        })
    }
}

#Preview {
    JournalListView()
}
