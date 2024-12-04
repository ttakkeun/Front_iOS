//
//  SignUpView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var container: DIContainer
    
    @StateObject var viewModel: SignUpViewModel
    
    @State var signUpRequest: SignUpRequest
    
    init(
        singUpRequest: SignUpRequest,
        container: DIContainer,
        appFlowViewModel: AppFlowViewModel
    ) {
        self.signUpRequest = singUpRequest
        self._viewModel = StateObject(wrappedValue: SignUpViewModel(container: container, appFlowViewModel: appFlowViewModel))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 43, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "본인확인",
                             currentPage: nil,
                             naviIcon: Image(systemName: "xmark"),
                             width: 14,
                             height: 14)
            
            
            emailField
            
            nicknameField
            
            agreementPart
            
            Spacer()
            
            MainButton(btnText: "완료",
                       width: 330,
                       height: 56,
                       action: {
                if viewModel.isAllMandatoryChecked {
                    viewModel.signUp(signUpRequet: returnSignUpData())
                }
            },
                       color: viewModel.isAllMandatoryChecked ? Color.mainPrimary : Color.gray200)
            .disabled(!viewModel.isAllMandatoryChecked)
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        .navigationBarBackButtonHidden()
    }
    
    private var emailField: some View {
        makeUserInfo(title: "이메일", placeholder: "이메일을 입력해주세요", value: $viewModel.userEmail)
    }
    
    private var nicknameField: some View {
        makeUserInfo(title: "닉네임", placeholder: "앱 내에서 사용할 회원님의 닉네임을 지어주세요.", value: $viewModel.userNickname)
    }
    
    private var agreementPart: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            makeTitle(text: "동의 항목")
            
            totalAgreement
            
            agreementGroup
        })
        .frame(width: 341, height: 255)
    }
    
    private var agreementGroup: some View {
        LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 20, content: {
            ForEach(viewModel.agreements, id: \.id) { item in
                HStack(alignment: .center, spacing: 17, content: {
                    
                    Button(action: {
                        viewModel.toggleCheck(for: item)
                    }, label: {
                        checkButtonImage(for: item.isChecked)
                            .resizable()
                            .frame(width: 30, height: 30)
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
            .padding(.leading, 15)
        })
        .frame(width: 341, height: 130)
        .sheet(item: $viewModel.selectedAgreement) { item in
            AgreementSheeetView(agreement: item)
                .presentationDragIndicator(.visible)
        }
    }
    
    private var totalAgreement: some View {
        HStack(alignment: .center, spacing: 16, content: {
            Button(action: {
                viewModel.toggleAllAgreements()
            }, label: {
                checkButtonImage(for: viewModel.isAllChecked)
                    .resizable()
                    .frame(width: 30, height: 30)
            })
            
            Text("전체동의")
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
        })
        .frame(width: 102, height: 30)
        .padding(.vertical, 19)
        .padding(.leading, 16)
        .padding(.trailing, 223)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.grayBorder)
        })
    }
}

extension SignUpView {
    
    func makeUserInfo(title: String, placeholder: String, value: Binding<String>) -> VStack<some View> {
        return VStack(alignment: .leading, spacing: 10, content: {
            makeTitle(text: title)
            
            CustomTextField(text: value, placeholder: placeholder)
        })
    }
    
    func makeTitle(text: String) -> Text {
        Text(text)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    func checkButtonImage(for ischecked: Bool) -> Image {
        return ischecked ? Icon.check.image : Icon.uncheck.image
    }
    
    func returnSignUpData() -> SignUpRequest {
        return SignUpRequest(identityToken: signUpRequest.identityToken, email: viewModel.userEmail, name: viewModel.userNickname)
    }
}
