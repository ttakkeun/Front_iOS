//
//  CustomAlert.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct CustomAlert: View {
    
    let alertText: Text
    var alertSubText: Text? = nil
    var aiCount: Int
    let alertAction: AlertAction
    let alertType: AlertType
    
    /* AI 진단 타입 Alert 초기화 */
    
    init(
        alertText: Text,
        aiCount: Int,
        alertAction: AlertAction,
        alertType: AlertType = .aiAlert
    ) {
        self.alertText = alertText
        self.aiCount = aiCount
        self.alertAction = alertAction
        self.alertType = alertType
    }
    
    init(
        alertText: Text,
        alertSubText: Text,
        aiCount: Int = 0,
        alertAction: AlertAction,
        alertType: AlertType = .normalAlert
    ) {
        self.alertText = alertText
        self.alertSubText = alertSubText
        self.aiCount = aiCount
        self.alertAction = alertAction
        self.alertType = alertType
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
                .frame(width: backGroundWidthCGFloat(), height: backGroundHeightCGFlaot())
            
            VStack(spacing: 30, content: {
                textGroup
                
                buttonGroup
            })
            .frame(width: stackCGFloat())
            .padding(.bottom, 17)
        })
    }
    
    @ViewBuilder
    private var textGroup: some View {
        switch alertType {
        case .aiAlert:
            alertText
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineSpacing(2.5)
        case .normalAlert:
            VStack(alignment: .leading, spacing: 20) {
                alertText
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray900)
                
                alertSubText
                    .font(.Body4_semibold)
                    .foregroundStyle(Color.gray400)
                    .lineLimit(2)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 301)
        }
    }
    
    @ViewBuilder
    private var buttonGroup: some View {
        switch alertType {
        case .aiAlert:
            makeAIAlert()
        case .normalAlert:
            normalAlert()
        }
    }
    
    @ViewBuilder
    func normalAlert() -> some View {
        HStack(spacing: 8, content: {
            
            Spacer()
            
            makeButton(text: "예",
                       action: {
                alertAction.yes()
                
                withAnimation(.spring(duration: 0.3)){
                    alertAction.showAlert.toggle()
                }
            },
                       color: Color.primarycolor200
            )
        })
        .frame(width: 301)
    }
    
    @ViewBuilder
    func  makeAIAlert() -> some View {
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
                
                makeButton(text: "아니오",
                           action: {
                    withAnimation(.spring(duration: 0.3)) {
                        alertAction.showAlert.toggle()
                    }
                },
                           color: Color.alertNo)
                
            } else {
                makeButton(text: "포인트가 부족합니다.",
                           action: {
                    withAnimation(.spring(duration: 0.3)) {
                        alertAction.showAlert.toggle()
                    }
                },
                           color: Color.alertNo)
            }
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
                .frame(maxWidth: buttonCGFloat())
                .background(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                })
        })
    }
    
    func backGroundWidthCGFloat() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 248
        case .normalAlert:
            return 338
        }
        
    }
    
    func backGroundHeightCGFlaot() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 175
        case .normalAlert:
            return 196
        }
    }
    
    func stackCGFloat() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 224
        case .normalAlert:
            return 301
        }
    }
    
    func buttonCGFloat() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 140
        case .normalAlert:
            return 82
        }
    }
}

struct AlertAction {
    @Binding var showAlert: Bool
    let yes: () -> Void
}

struct CustomAlert_Preview: PreviewProvider {
    static var previews: some View {
        CustomAlert(alertText: Text("문의내용이 접수되었습니다."), alertSubText: Text("회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n영업시간 2~3일 이내에 이메일로 답변을 받아보실 수 있습니다."), alertAction: .init(showAlert: .constant(true), yes: { print("ok") }))
    }
}
