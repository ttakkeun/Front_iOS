//
//  CustomAlert.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct CustomAlert: View {
    
    let alertText: Text
    let aiCount: Int
    let alertAction: AlertAction
    
    init(alertText: Text, aiCount: Int, alertAction: AlertAction) {
        self.alertText = alertText
        self.aiCount = aiCount
        self.alertAction = alertAction
    }
    
    var body: some View {
        ZStack {
            Color.customAlert.opacity(0.5)
                .ignoresSafeArea(.all)
            
            customAlertWindow
        }
        .animation(.easeInOut(duration: 0.5), value: alertAction.showAlert)
    }
    
    private var customAlertWindow: some View {
        ZStack(alignment: .bottom, content: {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 248, height: 175)
            
            VStack(spacing: 30, content: {
                alertText
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
                    .lineSpacing(2.5)
                
                buttonGroup
            })
            .frame(width: 224)
            .padding(.bottom, 17)
        })
    }
    
    
    private var buttonGroup: some View {
        HStack(spacing: 8, content: {
            if aiCount != 0 {
                makeButton(text: "예",
                           action: {
                    alertAction.yes()
                    
                    withAnimation(.spring(duration: 0.3)){
                        alertAction.showAlert.toggle()
                    }
                },
                           color: Color.primarycolor200
                )
            }
            
            makeButton(text: aiCount == 0 ? "포인트가 부족합니다." : "아니오",
                       action: {
                withAnimation(.spring(duration: 0.3)) {
                    alertAction.showAlert.toggle()
                }
            },
                       color: Color.alertNo)
        })
    }
    
    private func makeButton(text: String, action: @escaping () -> Void, color: Color) -> some View {
        Button(action: {
            action()
        }, label: {
            Text(text)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .padding(.vertical, 9)
                .frame(maxWidth: 140)
                .background(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                })
        })
    }
}

struct AlertAction {
    @Binding var showAlert: Bool
    let yes: () -> Void
}
