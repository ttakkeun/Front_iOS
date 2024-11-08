//
//  DiagnosingHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct DiagnosingValue {
    var selectedSegment: DiagnosingSegment
    var selectedPartItem: PartItem
}

struct DiagnosingHeader: View {
    
    @Binding var diagnosingValue: DiagnosingValue
    @Namespace var name
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21, content: {
            CustomSegment<DiagnosingSegment>(selectedSegment: $diagnosingValue.selectedSegment)
            
            itemsButton
        })
        .frame(width: 353, height: 78, alignment: .leading)
        .background(Color.clear)
    }
    
    private var itemsButton: some View {
        HStack(alignment: .center, spacing: 20, content: {
            ForEach(PartItem.allCases, id: \.self) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        diagnosingValue.selectedPartItem = item
                    }
                }, label: {
                    Text(item.toKorean())
                        .font(diagnosingValue.selectedPartItem == item ? .Body3_bold : .Body3_regular)
                        .foregroundStyle(diagnosingValue.selectedPartItem == item ? Color.gray900 : Color.gray600)
                        .background {
                            if diagnosingValue.selectedPartItem == item {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.primarycolor400)
                                    .frame(width: 30, height: 30)
                                    .animation(.easeInOut(duration: 0.1), value: diagnosingValue.selectedSegment)
                            }
                        }
                })
            }
        })
        .padding(.leading, 10)
    }
}


struct DiagnosingHeader_Preview: PreviewProvider {
    
    @State static var value = DiagnosingValue(selectedSegment: .journalList, selectedPartItem: .claw)
    
    static var previews: some View {
        DiagnosingHeader(diagnosingValue: $value)
    }
}
