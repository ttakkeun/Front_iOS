//
//  CameraButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI

struct CameraButton: View {
    
    let cameraText: Text
    let action: () -> Void
    
    init(
        cameraText: Text,
        action: @escaping () -> Void
    ) {
        self.cameraText = cameraText
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.answerBg)
                    .stroke(Color.gray200)
                    .frame(width: 80, height: 80)
                VStack(alignment: .center, spacing: 5, content: {
                    Icon.camera.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 47, height: 47)
                    
                    cameraText
                        .font(.Body5_medium)
                        .foregroundStyle(Color.gray400)
                })
            }
            .padding(.top, 5)
        })
    }
}
