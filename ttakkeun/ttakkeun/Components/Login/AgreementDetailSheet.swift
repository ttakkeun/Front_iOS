//
//  AgreementDetailSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/14/24.
//

import SwiftUI

/// 동의항목 자세한 사항 확인을 위한 시트뷰
struct AgreementDetailSheet: View {
    
    var agreement: AgreementData

    //MARK: - Content
    var body: some View {
        VStack {
            /// 제목
            Text(agreement.title)
                .font(.headline)
                .padding()

            /// 내용
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(agreement.detailText, id: \.section) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.section)
                                .font(.Body2_bold)
                                .foregroundStyle(Color.gray_900)
                            
                            // section.text에서 \n가 나오면 단락으로 나누어 간격 더 주기
                            let paragraphs = section.text.components(separatedBy: "\n")
                            ForEach(paragraphs, id: \.self) { paragraph in
                                Text(paragraph)
                                    .font(.Body3_medium)
                                    .foregroundStyle(Color.gray_900)
                                    .padding(.bottom, 1)
                            }
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.all)
        }
    }
}
