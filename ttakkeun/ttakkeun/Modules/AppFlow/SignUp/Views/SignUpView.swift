//
//  SignUpView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

/// 회원가입뷰
struct SignUpView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: SignUpViewModel
    var signup: SignUpData
    
    let socialType: SocialLoginType
    
    // MARK: - Constants
    fileprivate enum SignUpConstants {
        static let topVspacing: CGFloat = 10
        static let agreementVspacing: CGFloat = 16
        static let totalHspacing: CGFloat = 16
        static let agreementHspacing: CGFloat = 17
        static let individualAgreementVspacing: CGFloat = 20
        static let userInfoVspacing: CGFloat = 10
        
        static let totalContentsPadding: CGFloat = 16
        static let agreementPadding: CGFloat = 15
        
        static let topSpacerHeight: CGFloat = 76
        static let totalAgreementHeight: CGFloat = 68
        static let cornerRadius: CGFloat = 10
        static let sheetCornerRadius: CGFloat = 20
        static let checkBoxSize: CGFloat = 30
        
        static let customNavigationText: String = "본인확인"
        static let topNaviIconText: String = "chevron.left"
        static let emailFieldText: String = "이메일"
        static let nicknameFieldText: String = "닉네임"
        static let nicknamePlaceholder: String = "닉네임을 지어주세요(최대 8자)"
        static let agreementText: String = "동의 항목"
        static let totalAgreementText: String = "전체 동의"
        static let mainButtonText: String = "완료"
    }
    
    // MARK: - Init
    init(
        socialType: SocialLoginType,
        signup: SignUpData,
        container: DIContainer,
        appFlowViewModel: AppFlowViewModel
    ) {
        self.socialType = socialType
        self.signup = signup
        self.viewModel = .init(container: container, appFlowViewModel: appFlowViewModel)
    }
    
    // MARK: - Contents
    var body: some View {
        VStack(alignment: .center, spacing: .zero, content: {
            topContents
            Spacer().frame(maxHeight: SignUpConstants.topSpacerHeight)
            middleContents
            Spacer()
            bottomContents
        })
        .ignoresSafeArea(.keyboard)
        .safeAreaPadding(EdgeInsets(top: UIConstants.safeTop, leading: UIConstants.safeLeading, bottom: .zero, trailing: UIConstants.safeTrailing))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .customNavigation(title: SignUpConstants.customNavigationText, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: SignUpConstants.topNaviIconText))
        .sheet(item: $viewModel.selectedAgreement) { item in
            AgreementSheeetView(agreement: item)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(SignUpConstants.sheetCornerRadius)
        }
    }
    
    // MARK: - TopContents
    private var topContents: some View {
        VStack(alignment: .leading, spacing: SignUpConstants.topVspacing, content: {
            emailField
            nicknameField
        })
    }
    private var emailField: some View {
        makeUserInfo(title: SignUpConstants.emailFieldText, placeholder: signup.email, value: .constant(""))
            .disabled(true)
    }
    
    private var nicknameField: some View {
        makeUserInfo(title: SignUpConstants.nicknameFieldText, placeholder: SignUpConstants.nicknamePlaceholder, value: $viewModel.userNickname)
    }
    
    // MARK: - MiddleContents
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: SignUpConstants.agreementVspacing, content: {
            makeTitle(text: SignUpConstants.agreementText)
            totalAgreement
            agreementGroup
        })
    }
    
    @ViewBuilder
    private var agreementGroup: some View {
        VStack(alignment: .leading, spacing: SignUpConstants.individualAgreementVspacing, content: {
            ForEach(viewModel.agreements, id: \.id) { item in
                individualAgreement(item: item)
            }
            .padding(.leading, SignUpConstants.agreementPadding)
        })
    }
    
    private func individualAgreement(item: AgreementData) -> some View {
        HStack(alignment: .center, spacing: SignUpConstants.agreementHspacing, content: {
            
            Button(action: {
                viewModel.toggleCheck(for: item)
            }, label: {
                checkButtonImage(for: item.isChecked)
                    .resizable()
                    .frame(width: SignUpConstants.checkBoxSize, height: SignUpConstants.checkBoxSize)
            })
            
            Button(action: {
                viewModel.selectedAgreement = item
            }, label: {
                Text(item.title)
                    .font(.Body2_regular)
                    .foregroundStyle(Color.gray900)
                    .underline(true, color: Color.gray500)
            })
        })
    }
    
    private var totalAgreement: some View {
        ZStack(alignment: .leading, content: {
            RoundedRectangle(cornerRadius: SignUpConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.grayBorder)
                .frame(height: SignUpConstants.totalAgreementHeight)
            
            totalInContents
        })
    }
    
    private var totalInContents: some View {
        HStack(alignment: .center, spacing: SignUpConstants.totalHspacing, content: {
            Button(action: {
                viewModel.toggleAllAgreements()
            }, label: {
                checkButtonImage(for: viewModel.isAllChecked)
                    .resizable()
                    .frame(width: SignUpConstants.checkBoxSize, height: SignUpConstants.checkBoxSize)
            })
            
            Text(SignUpConstants.totalAgreementText)
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
        })
        .padding(.leading, SignUpConstants.totalContentsPadding)
    }
    
    // MARK: - BottomContents
    private var bottomContents: some View {
        MainButton(btnText: SignUpConstants.mainButtonText,
                   action: {
            if viewModel.isAllMandatoryChecked {
                switch socialType {
                case .kakao:
                    viewModel.signUpKakao(signUpRequet: returnSignUpData())
                    UserState.shared.setLoginType(.kakao)
                case .apple:
                    viewModel.signUpApple(signUpRequet: returnSignUpData())
                    UserState.shared.setLoginType(.apple)
                }
            }
        },
                   color: viewModel.isAllMandatoryChecked ? Color.mainPrimary : Color.gray200)
        .disabled(!viewModel.isAllMandatoryChecked)
    }
}

extension SignUpView {
    func makeUserInfo(title: String, placeholder: String, value: Binding<String>) -> VStack<some View> {
        return VStack(alignment: .leading, spacing: SignUpConstants.userInfoVspacing, content: {
            makeTitle(text: title)
            
            TextField("", text: value, prompt: makePlaceholder(text: placeholder))
                .textFieldStyle(ttakkeunTextFieldStyle())
        })
    }
    
    func makeTitle(text: String) -> Text {
        Text(text)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    func checkButtonImage(for ischecked: Bool) -> Image {
        return ischecked ? Image(.check) : Image(.uncheck)
    }
    
    // 카카오 및 애플 로그인 분기처리
    func returnSignUpData() -> SignUpRequest {
        return SignUpRequest(identityToken: signUpRequest.identityToken, email: signUpRequest.email, name: viewModel.userNickname)
    }
    
    func makePlaceholder(text: String) -> Text {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(.gray400)
    }
}

#Preview {
    SignUpView(socialType: .apple, singUpRequest: .init(identityToken: "s", email: "s", name: "S"), container: DIContainer(), appFlowViewModel: AppFlowViewModel())
        .environment(AppFlowViewModel())
        .environmentObject(DIContainer())
}
