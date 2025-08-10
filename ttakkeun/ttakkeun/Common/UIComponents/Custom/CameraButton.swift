//
//  CameraButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI

/// 카메라버튼
struct CameraButton: View {
    
    // MARK: - Property
    let cameraText: Text
    let action: () -> Void
    
    // MARK: - Constants
    fileprivate enum CameraButtonConstants {
        static let cornerRadius: CGFloat = 10
        static let rectangleSize: CGFloat = 80
        static let cameraSize: CGFloat = 47
        static let vSpacing: CGFloat = 5
        static let topPadding: CGFloat = 3
    }
    
    // MARK: - Init
    init(
        cameraText: Text,
        action: @escaping () -> Void
    ) {
        self.cameraText = cameraText
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: CameraButtonConstants.cornerRadius)
                    .fill(Color.answerBg)
                    .stroke(Color.gray200)
                    .frame(width: CameraButtonConstants.rectangleSize, height: CameraButtonConstants.rectangleSize)
                
                VStack(alignment: .center, spacing: CameraButtonConstants.vSpacing, content: {
                    Image(.camera)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CameraButtonConstants.cameraSize, height: CameraButtonConstants.cameraSize)
                    
                    cameraText
                        .font(.Body5_medium)
                        .foregroundStyle(Color.gray400)
                })
            }
        })
        .padding(.top, CameraButtonConstants.topPadding)
    }
}

#Preview {
    CameraButton(cameraText: Text("이미지 선택하기"), action: {
        print("hello")
    })
}
