//
//  AgreementDetailSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/14/24.
//

import SwiftUI

struct AgreementDetailSheet: View {
    var agreement: AgreementData
    
    //MARK: - INIT
    init(agreement: AgreementData) {
        self.agreement = agreement
    }

    var body: some View {
        VStack {
            Text(agreement.title)
                .font(.headline)
                .padding()
            
            ScrollView {
                Text(agreement.detailText)
                    .padding()
            }
        }
    }
}
