//
//  CustomNavigation.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

struct CustomNavigation: View {
    
    let action: Void
    let currentPage: Int
    
    init(
        action: @escaping () -> Void,
        currentPage: Int
    ) {
        self.action = action()
        self.currentPage = currentPage
    }
    
    var body: some View {
        HStack(alignment: .center, content: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 14, height: 14)
            
            Spacer()
            
            Text("\(currentPage) / 5")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray_900)
        })
    }
}

struct customNavigation_Preview: PreviewProvider {
    static var previews: some View {
        CustomNavigation(action: {
            print("hello")
        }, currentPage: 1)
            .previewLayout(.sizeThatFits)
    }
}
