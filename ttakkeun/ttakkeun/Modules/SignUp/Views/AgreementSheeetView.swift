//
//  AgreementSheeetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import SwiftUI

struct AgreementSheeetView: View {
    
    var agreement: AgreementData
    
    init(agreement: AgreementData) {
        self.agreement = agreement
    }
    
    var body: some View {
        VStack {
            titleText
            contentText
        }
        .padding(.top, 20)
    }
    
    private var titleText: some View {
        Text(agreement.title)
            .font(.headline)
            .padding()
    }
    
    private var contentText: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15, content: {
                ForEach(agreement.detailText, id: \.section) { section in
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text(section.section)
                            .font(.Body2_bold)
                            .foregroundStyle(Color.gray900)
                        
                        let paragraphs = section.text.components(separatedBy: "\n")
                        ForEach(paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.Body3_medium)
                                .foregroundStyle(Color.gray900)
                                .padding(.bottom, 1)
                        }
                    })
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                }
            })
            .padding(.horizontal, 10)
        }
        .frame(maxHeight: .infinity).ignoresSafeArea(.all)
        .padding(.bottom, 10)
    }
}

