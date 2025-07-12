//
//  PetInfo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

/// 홈 펫 프로필 펫 이름 및 생일 정보
struct PetInfoTitle: View {
    
    // MARK: - Property
    let name: String
    let birth: String
    
    // MARK: - Constants
    fileprivate enum PetInfoTitleConstants {
        static let petProfileVspacing: CGFloat = 2
    }
    
    // MARK: - Init
    init(name: String, birth: String) {
        self.name = name
        self.birth = birth
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: PetInfoTitleConstants.petProfileVspacing, content: {
            Text(name)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            Text(birth.formattedDate())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray400)
        })
    }
}
