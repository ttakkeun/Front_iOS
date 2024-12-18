//
//  AgreementSheetView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/18/24.
//

import SwiftUI

struct AgreementSheetView: View {
    
    var agreement: AgreementData

    var body: some View {
        VStack(alignment: .center, spacing: 15,content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            Text("이용약관")
                .font(.H3_bold)
                .foregroundStyle(Color.gray900)
            
            terms
            
            Spacer()
        })
        .safeAreaPadding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
    
    private var terms: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            /// 제목
            Text(agreement.title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
                .padding(.leading, 18)
            
            /// 내용
            VStack(alignment: .leading, spacing: 15) {
                ForEach(agreement.detailText, id: \.section) { section in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(section.section) // 섹션 제목
                            .font(.Body4_medium)
                            .foregroundStyle(Color.gray900)
                        
                        // \n을 기준으로 단락 나누기
                        let paragraphs = section.text.components(separatedBy: "\n")
                        ForEach(paragraphs, id: \.self) { paragraph in
                            if !paragraph.isEmpty {
                                Text(paragraph)
                                    .font(.Body4_medium)
                                    .foregroundStyle(Color.gray900)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 10)
                }
            }
        })
    }
}

//MARK: - Preview
struct AgreementSheetView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            InquireView(container: DIContainer(), selectedCategory: "서비스 이용 문의")
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}

