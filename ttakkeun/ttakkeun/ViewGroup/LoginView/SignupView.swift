//
//  AgreementView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/13/24.
//

import SwiftUI

/// 본인확인 및 동의항목 뷰
struct SignupView: View {
    @StateObject var viewModel: AgreementViewModel = AgreementViewModel()
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @EnvironmentObject var container: DIContainer
        
    @Environment(\.dismiss) var dismiss
    var signUpData: SignUpData
    
    init(signUpData: SignUpData) {
        self.signUpData = signUpData
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, spacing: 50, content: {
            CustomNavigation(action: {
                dismiss()
            }, title: "본인확인", currentPage: nil, naviIcon: Image(systemName: "xmark"), width: 14, height: 14)
            
            emailField
            
            agreementPart
            
            Spacer()
            
            registerBtn
        })
        .navigationBarBackButtonHidden()
    }
    
    /// 로그인 후 넘겨받은 이메일 출력
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("이메일")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            Text(verbatim: signUpData.email)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_400)
                    .frame(width: 325, height: 44, alignment: .leading)
                    .padding(.leading, 15)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray_200, lineWidth: 1)
                    )
        })
    }
    
    ///동의항목 파트(타이틀 + 네모 박스)
    private var agreementPart: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("동의 항목")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            agreements
                .frame(width: 341, height: 167, alignment: .leading)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
            
            totalAgreement
        })
        .frame(width: 341, height: 248)
    }
    
    
    /// 동의항목 선택 요소들
    private var agreements: some View {
        
        /// 3가지 동의항목
        LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 20) {
            ForEach(viewModel.agreements, id: \.id) { item in
                HStack(alignment: .center, spacing: 17, content: {
                    checkmarkImage(for: item.isChecked)
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.toggleCheck(for: item)
                        }
                    
                    Button(action: {
                        viewModel.selectedAgreement = item
                    }, label: {
                        Text(item.title)
                            .font(.Body2_regular)
                            .foregroundStyle(Color.gray_900)
                            .underline(true, color: Color.gray_500)
                    })
                })
            }
            .padding(.leading, 19)
        }
        .frame(width: 341, height: 167, alignment: .leading)
        ///텍스트 누르면 해당 동의항목 자세한 사항들 시트뷰로 뜸
        .sheet(item: $viewModel.selectedAgreement) { item in
            AgreementDetailSheet(agreement: item)
                .presentationDragIndicator(.visible)
        }
    }
    
    /// 전체 동의 버튼
    private var totalAgreement: some View {
        HStack(alignment: .center, spacing: 9, content: {
            Spacer()
            
            checkmarkImage(for: viewModel.isAllChecked)
                .resizable()
                .frame(width: 23, height: 23)
                .onTapGesture {
                    viewModel.toggleAllAgreements()
                }
            
            Text("전체동의")
                .font(.Body2_bold)
                .foregroundStyle(Color.gray_900)
                .onTapGesture {
                    viewModel.toggleAllAgreements()
                }
        })
    }
    
    /// 완료 버튼
    private var registerBtn: some View {
        MainButton(
            btnText: "완료",
            width: 339,
            height: 63,
            action: {
                Task {
                    
                    if viewModel.isAllMandatoryChecked {
                        await viewModel.signUp(token: signUpData.token, name: signUpData.name)
                        container.navigationRouter.pop()
                        appFlowViewModel.onSignUpSuccess()
                    }
                }
            },
            color: viewModel.isAllMandatoryChecked ? Color.primaryColor_Main : Color.gray_200
        )
        .disabled(!viewModel.isAllMandatoryChecked)
    }
    
    //MARK: - Function
    /// 체크 상태에 따른 이미지를 반환하는 함수
    private func checkmarkImage(for isChecked: Bool) -> Image {
        return isChecked ? Icon.check.image : Icon.uncheck.image
    }
    
}


//MARK: - Preview
struct SignupView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SignupView(signUpData: SignUpData(token: "123", email: "123", name: "123123"))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
