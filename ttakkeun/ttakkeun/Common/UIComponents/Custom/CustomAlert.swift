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
    
    var nickNameValue: Binding<String>? = nil
    
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
    
    /* 문의하기, 신고하기 타입 Alert 초기화 */
    
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
    
    /* NickName Alert 초기화 */
    
    init(
        alertText: Text,
        alertSubText: Text,
        aiCount: Int = 0,
        alertAction: AlertAction,
        alertType: AlertType = .editNicknameAlert,
        nickNameValue: Binding<String>
    ) {
        self.alertText = alertText
        self.alertSubText = alertSubText
        self.aiCount = aiCount
        self.alertAction = alertAction
        self.alertType = alertType
        self.nickNameValue = nickNameValue
    }
    
    var body: some View {
        ZStack {
            Color.customAlert.opacity(0.7)
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
                    .frame(width: 300, alignment: .leading)
                    .font(.Body4_semibold)
                    .foregroundStyle(Color.gray400)
                    .lineLimit(2)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 301)
            
        case .editNicknameAlert:
            VStack(alignment: .leading, spacing: 17, content: {
                
                HStack(content: {
                    alertText
                        .font(.Body2_semibold)
                        .foregroundStyle(Color.gray900)
                    
                    Spacer()
                    
                    alertSubText
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray400)
                })
                
                if let nickName = nickNameValue {
                    CustomTextField(text: nickName, placeholder: "바꾸고자 하는 닉네임을 입력해주세요.", maxWidth: 301, maxHeight: 47)
                }
            })
            .frame(width: 301)
            
        case .deleteAccountAlert:
            HStack {
                VStack(alignment: .leading, spacing: 10) {
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
                
                Spacer()
                
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
        case .editNicknameAlert:
            editNickNameAlert()
        case .deleteAccountAlert:
            deleteAccountAlert()
        }
    }
    
    func deleteAccountAlert() -> some View {
        HStack(spacing: 8, content: {
            makeButton(text: "취소", action: {
                withAnimation(.spring(duration: 0.3)) {
                    alertAction.showAlert.toggle()
                }
            }, color: Color.alertNo)
            
            Spacer()
            
            makeButton(text: "완료", action: {
                alertAction.yes()
                
                withAnimation(.spring(duration: 0.3)){
                    alertAction.showAlert.toggle()
                }
                
            }, color: Color.primarycolor200)
        })
    }
    
    func editNickNameAlert() -> some View {
        HStack(spacing: 8, content: {
            makeButton(text: "취소", action: {
                withAnimation(.spring(duration: 0.3)) {
                    alertAction.showAlert.toggle()
                }
            }, color: Color.alertNo)
            
            Spacer()
            
            makeButton(text: "완료", action: {
                
                if let _ = nickNameValue {
                    
                    alertAction.yes()
                       
                    withAnimation(.spring(duration: 0.3)){
                        alertAction.showAlert.toggle()
                    }
                }
            }, color: Color.primarycolor200)
        })
    }
    
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
    
    func makeAIAlert() -> some View {
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
                .frame(maxWidth: buttonCGFloat(), maxHeight: 39)
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
        case .normalAlert, .editNicknameAlert, .deleteAccountAlert:
            return 338
        }
        
    }
    
    func backGroundHeightCGFlaot() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 175
        case .normalAlert, .editNicknameAlert:
            return 196
        case .deleteAccountAlert:
            return 175
        }
    }
    
    func stackCGFloat() -> CGFloat {
        switch alertType {
        case .aiAlert:
            return 224
        case .normalAlert, .editNicknameAlert, .deleteAccountAlert:
            return 301
        }
    }
    
    func buttonCGFloat() -> CGFloat {
        switch alertType {
        case .aiAlert, .editNicknameAlert, .deleteAccountAlert:
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
        /* 문의하기 및 신고하기 프리뷰 */
          CustomAlert(alertText: Text("신고내용이 접수되었습니다."), alertSubText: Text("회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n회원님의 소중한 의견을 잘 반영하도록 하겠습니다."), alertAction: .init(showAlert: .constant(true), yes: { print("ok") }))
        
        /* 닉네임 변경 프리뷰 */
//        CustomAlert(alertText: Text("닉네임 수정하기"), alertSubText: Text(UserState.shared.getUserName()), alertAction: .init(showAlert: .constant(true), yes: { print("yes") }), nickNameValue: .constant(""))
        
        /* ai alert */
//        CustomAlert(alertText: Text("선택된 2개의 일지로 \n따끈 AI 진단을 진행하시겠습니까?"), aiCount: 10, alertAction: .init(showAlert: .constant(true), yes: {print("yes")}))
        
//        CustomAlert(alertText: Text("탈퇴하기"), alertSubText: Text("정말 따끈을 떠나시겠습니까?"), alertAction: .init(showAlert: .constant(true), yes: { print("ok") }), alertType: .deleteAccountAlert)
    }
}
