//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        topTitle
    }
    
    // MARK: - ContentComponents
    
    private var topTitle: some View {
        VStack(alignment: .center, spacing: 20, content: {
            Text("따끈")
                .font(.santokki(type: .regular, size: 40))
                .foregroundStyle(Color.mainTextColor_Color)
                .frame(maxHeight: 80)
            Text("새로운 가족을 등록해주세요!")
                .font(.suit(type: .bold, size: 20))
        })
    }
}

struct ProfielView_Preview: PreviewProvider {
    
    static let devices: [String] = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices , id: \.self) { device in
            ProfileView()
        }
    }
}
