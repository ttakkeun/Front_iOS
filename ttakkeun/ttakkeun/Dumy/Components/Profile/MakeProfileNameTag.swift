//
//  MakeProfileNameTag.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/29/24.
//

import SwiftUI

/// 프로필 생성뷰 각 필드 네임태그 + 필수표시 별
struct MakeProfileNameTag: View {
    
    var titleText: String
    var mustMark: Bool
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - titleText: 네임태그 텍스트
    ///   - mustMark: 필수 작성해야 하는 필드 표시하는 마크 유무
    init(titleText: String, mustMark: Bool) {
        self.titleText = titleText
        self.mustMark = mustMark
    }
    
    //MARK: - Contents
    /// 네임태그 기본적인 구조
    var body: some View {
        HStack(alignment: .top, spacing: 2, content: {
            Text(titleText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            if mustMark {
                Text("*")
                    .font(.H4_bold)
                    .foregroundStyle(Color.redStarColor)
                    .padding(.top, -6)
            }
            
        })
        .frame(width: 306, height: 20, alignment: .leading)
    }
}

//MARK: - Preiview
struct MakeProfileNameTag_Preview: PreviewProvider {
    static var previews: some View {
        MakeProfileNameTag(titleText: "이름", mustMark: true)
    }
}

