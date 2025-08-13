//
//  CustomAlert.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 커스텀 Alert 뷰
struct CustomAlert: View {
    
    // MARK: - Property
    let alertType: AlertType
    let yes: () -> Void
    @Binding var showAlert: Bool
    @Binding var nickNameValue: String
    
    // MARK: - Constants
    fileprivate enum CustomAlertConstants {
        static let safeHorizonPadding: CGFloat = 25
        static let alertContentsSpacing: CGFloat = 30
        static let bottomButtonHspacing: CGFloat = 8
        static let titleSubTitleVspacing: CGFloat = 17
        
        static let buttonWidth: CGFloat = 108
        static let buttonHeight: CGFloat = 45
        
        static let animationTime: TimeInterval = 0.5
        static let buttonAnimationTime: TimeInterval = 0.3
        
        static let lineSpaciing: CGFloat = 2.5
        static let bgOpacity: Double = 0.7
        static let cornerRadius: CGFloat = 10
        
        static let nicknameText: String = "바꾸고자 하는 닉네임을 입력해주세요"
    }
    
    // MARK: - Init
    /* AI 진단 타입 Alert 초기화 */
    /* 문의하기, 신고하기 타입 Alert 초기화 */
    init(
        alertType: AlertType,
        showAlert: Binding<Bool>,
        yes: @escaping () -> Void
    ) {
        self.alertType = alertType
        self._showAlert = showAlert
        self.yes = yes
        self._nickNameValue = .constant("")
    }
    
    /* NickName Alert 초기화 */
    init(
        alertType: AlertType,
        showAlert: Binding<Bool>,
        yes: @escaping () -> Void,
        nickNameValue: Binding<String>
    ) {
        self.alertType = alertType
        self._showAlert = showAlert
        self.yes = yes
        self._nickNameValue = nickNameValue
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.customAlert.opacity(CustomAlertConstants.bgOpacity)
                .ignoresSafeArea(.all)
            customAlertWindow
        }
        .animation(.easeInOut(duration: CustomAlertConstants.animationTime), value: self.showAlert)
    }
    
    /// Alert 창
    private var customAlertWindow: some View {
        VStack(alignment: .leading, spacing: CustomAlertConstants.alertContentsSpacing, content: {
            topContents
            bottomContents
        })
        .padding(UIConstants.defaultSafeHorizon)
        .background {
            RoundedRectangle(cornerRadius: CustomAlertConstants.cornerRadius)
                .fill(Color.white)
        }
        .safeAreaPadding(.horizontal, CustomAlertConstants.safeHorizonPadding)
    }
    
    // MARK: - TopContents
    @ViewBuilder
    private var topContents: some View {
        switch alertType {
        case .editNicknameAlert:
            nicknameConstents
        default:
            defaultContents
        }
    }
    /// Alert 내부 상단 컨텐츠
    private var defaultContents: some View {
        VStack(alignment: .leading, spacing: CustomAlertConstants.titleSubTitleVspacing, content: {
            title
            subtitle
        })
        .lineLimit(nil)
        .lineSpacing(CustomAlertConstants.lineSpaciing)
        .multilineTextAlignment(.leading)
    }
    
    /// 닉네임 컨텐츠
    private var nicknameConstents: some View {
        VStack(alignment: .leading, spacing: CustomAlertConstants.titleSubTitleVspacing, content: {
            HStack {
                title
                Spacer()
                subtitle
            }
            TextField("", text: $nickNameValue, prompt: placeholder)
                .textFieldStyle(ttakkeunTextFieldStyle())
        })
    }
    
    /// 타이틀
    private var title: some View {
        Text(alertType.title)
            .font(alertType.font[0])
            .foregroundStyle(alertType.fontColor[0])
    }
    
    /// 서브 타이틀
    private var subtitle: some View {
        Text(alertType.subtitle)
            .font(alertType.font[1])
            .foregroundStyle(alertType.fontColor[1])
    }
    
    private var placeholder: Text {
        Text(CustomAlertConstants.nicknameText)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
    }
    
    // MARK: - BottomContents
    /// 하단 컨텐츠
    @ViewBuilder
    private var bottomContents: some View {
        switch alertType {
        case .aiAlert, .editNicknameAlert, .deleteProfileAlert, .logoutProfileAlert, .deleteAccountAlert:
            yesAlert
        case .noAiCountAlert:
            noAiCount
        case .receivingReportAlert, .receivingInquiryAlert:
            completeAlert
        }
    }
    
    /// 예 전용 버튼
    private var yesAlert: some View {
        buttonContetns(contents: {
            makeButton(buttonType: .yes, action: {
                self.yes()
                self.showAlert = false
            })
        })
    }
    
    /// AI Count 없을 때 버튼
    private var noAiCount: some View {
        makeButton(buttonType: .yes, action: {
            self.showAlert = false
        })
    }
    
    /// 완료 버튼
    private var completeAlert: some View {
        makeButton(buttonType: .complete, action: {
            self.showAlert = false
        })
    }
    
    // MARK: - ButtonContents
    private func buttonContetns(@ViewBuilder contents: () -> some View) -> some View {
        HStack(spacing: CustomAlertConstants.bottomButtonHspacing, content: {
            cancelButton
            Spacer()
            contents()
        })
    }
    
    private var cancelButton: some View {
        makeButton(buttonType: .no, action: {
            self.showAlert = false
        })
    }
    
    private func makeButton(buttonType: AlertButtonType, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(duration: CustomAlertConstants.buttonAnimationTime)) {
                action()
            }
        }, label: {
            buttonShape(buttonType: buttonType)
        })
    }
    
    /// 버튼 형태 구성
    /// - Parameter buttonType: 버튼 타입 선택
    /// - Returns: 버튼 뷰 반환
    private func buttonShape(buttonType: AlertButtonType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CustomAlertConstants.cornerRadius)
                .foregroundStyle(buttonType.color)
                .frame(minWidth: CustomAlertConstants.buttonWidth, maxHeight: CustomAlertConstants.buttonHeight)
            
            Text(buttonType.text)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
        }
    }
}
