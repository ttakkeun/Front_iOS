//
//  NameTag.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct NameTag: View {
    
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
                .foregroundStyle(Color.gray900)
            
            if mustMark {
                Text("*")
                    .font(.H4_bold)
                    .foregroundStyle(Color.redStar)
                    .padding(.top, -6)
            }
        })
        .frame(alignment: .leading)
    }
}


struct NameTag_Preview: PreviewProvider {
    static var previews: some View {
        NameTag(titleText: "중성화여부", mustMark: true)
    }
}
