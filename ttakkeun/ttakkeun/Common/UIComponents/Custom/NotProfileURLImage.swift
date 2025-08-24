//
//  NotProfileURLImage.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/24/25.
//

import SwiftUI

struct NotProfileURLImage: View {
    let size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    var body: some View {
        Image(systemName: "person.slash.fill")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.black)
            .frame(width: size.width - 30, height: size.height)
            .symbolEffect(.bounce, options: .repeat(2))
    }
}
