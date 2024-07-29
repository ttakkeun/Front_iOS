//
//  MakeProfileTitle.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/29/24.
//

import SwiftUI

struct MakeProfileNameTag: View {
    
    var titleText: String
    var mustMark: Bool
    
    init(titleText: String, mustMark: Bool) {
        self.titleText = titleText
        self.mustMark = mustMark
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 2, content: {
            Text(titleText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            Text("*")
                .font(.H4_bold)
                //TODO: - ColorSet 추가해서 색상 변경해야함!!!
                .foregroundStyle(Color.red)
                .padding(.top, -6)
        })
        .frame(width: 331, height: 20, alignment: .leading)
    }
}

//MARK: - Preiview
struct MakeProfileNameTag_Preview: PreviewProvider {
    static var previews: some View {
        MakeProfileNameTag(titleText: "이름", mustMark: true)
    }
}

