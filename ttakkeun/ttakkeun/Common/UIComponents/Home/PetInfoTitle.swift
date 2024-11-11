//
//  PetInfo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct PetInfoTitle: View {
    
    let name: String
    let birth: String
    
    init(name: String, birth: String) {
        self.name = name
        self.birth = birth
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2, content: {
            Text(name)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
            
            Text(DataFormatter.shared.formattedDate(from: birth))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray400)
        })
        .padding(.top, 10)
    }
}
