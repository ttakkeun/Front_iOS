//
//  NameTag.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct NameTag: View {
    
    // MARK: - Property
    var titleText: String
    var mustMark: Bool
    
    // MARK: - Constants
    fileprivate enum NameTagConstants {
        static let hSpacing: CGFloat = 2
        static let markPadding: CGFloat = -6
        static let importantText: String = "*"
    }
    
    // MARK: - Init
    init(titleText: String, mustMark: Bool) {
        self.titleText = titleText
        self.mustMark = mustMark
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: NameTagConstants.hSpacing, content: {
            Text(titleText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            if mustMark {
                Text(NameTagConstants.importantText)
                    .font(.H4_bold)
                    .foregroundStyle(Color.redStar)
                    .padding(.top, NameTagConstants.markPadding)
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
