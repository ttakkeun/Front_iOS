//
//  DeleteAccountView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

/// 회원 탈퇴하기 뷰
struct DeleteAccountView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Environment(\.appFlow) var appFlowViewModel
    @State var viewModel: DeleteAccountViewModel
    @AppStorage(AppStorageKey.userEmail) var userEmail: String = "유저 이메일을 불러오지 못했습니다."
    @Environment(\.alert) var alert
    @FocusState var isFoucsed: Bool
    
    // MARK: - Constants
    fileprivate enum DeleteAccountConstants {
        static let firstContentsVspacing: CGFloat = 16
        static let firstMiddleVspacing: CGFloat = 24
        static let firstImportantNotice: EdgeInsets = .init(top: 16, leading: 16, bottom: 4, trailing: 17)
        static let secondEmailVspacing: CGFloat = 10
        static let secondTopVspacing: CGFloat = 13
        static let secondMiddleVspacing: CGFloat = 23
        static let secondContentsVspacing: CGFloat = 52
        static let secondDeleteReasonHspacing: CGFloat = 14
        static let spacerMin: CGFloat = 190
        
        static let checkIconSize: CGSize = .init(width: 25, height: 25)
        static let checkBtnSize: CGSize = .init(width: 20, height: 20)
        static let textEditorSize: CGSize = .init(width: 0, height: 200)
        
        static let mainBtnHeight: CGFloat = 63
        static let cornerRadius: CGFloat = 10
        static let maxCount: Int = 200
        
        static let firstBtnText: String = "다음"
        static let firstTitle: String = "회원 탈퇴 전, 유의 사항을 확인해주세요"
        static let firstConfirmText: String = "탈퇴 시, 위 유의사항을 확인하였음에 동의합니다."
        static let secondEmailText: String = "보안을 위해, 회원님의 계정 이메일을 확인합니다."
        static let secondOwnerCheckText: String = "본인 계정이 맞습니까?"
        static let secondTitle: String = "탈퇴사유를 알려주시면 저희한테 큰 도움이 됩니다. \n"
        static let secondSubTitle: String = "(중복 선택 가능)"
        static let secondBtnBeforText: String = "이전"
        static let secondBtnCompleteText: String = "탈퇴하기"
        static let naviTite: String = "회원 탈퇴"
        static let naviCloseButton: String = "xmark"
        static let checkImage: (String, String) = ("checkmark.circle.fill", "circle")
        static let placeholder: String = "입력해주세요."
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            switch viewModel.currentPage {
            case .firstPage:
                firstPageContents
            case .secondPage:
                secondPageContents
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: DeleteAccountConstants.naviTite, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: DeleteAccountConstants.naviCloseButton))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .customAlert(alert: alert)
        .keyboardToolbar {
            isFoucsed = false
        }
    }
    
    // MARK: - FirstPage
    
    /// 회원 탈퇴 유의 사항 첫 페인지
    private var firstPageContents: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.firstContentsVspacing, content: {
            firstTopTitle
            firstMiddleContents
            Spacer()
            generateButton(DeleteAccountConstants.firstBtnText, btnCondition: viewModel.isAgreementCheck, action: {
                viewModel.currentPage = .secondPage
            })
            .disabled(!viewModel.isAgreementCheck)
        })
    }
    
    /// 첫 페이지 상단 유의사항 타이틀
    private var firstTopTitle: some View {
        Text(DeleteAccountConstants.firstTitle)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 첫 페이지 유의 사항 내용
    private var firstMiddleContents: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.firstMiddleVspacing, content: {
            agreementMessage
            agreeConfirmTerms
        })
    }
    
    /// 유의 사항 관련 글 내용
    private var agreementMessage: some View {
        Text(DeletePageType.firstPageContents)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray700)
            .padding(DeleteAccountConstants.firstImportantNotice)
            .background {
                RoundedRectangle(cornerRadius: DeleteAccountConstants.cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray300, style: .init())
            }
    }
    
    /// 유의사항 동의 체크 필드
    private var agreeConfirmTerms: some View {
        HStack {
            Text(DeleteAccountConstants.firstConfirmText)
                .font(.Body3_regular)
                .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Button(action: {
                viewModel.isAgreementCheck.toggle()
            }, label: {
                checkMarkImage(for: viewModel.isAgreementCheck)
                    .resizable()
                    .frame(width: DeleteAccountConstants.checkIconSize.width, height: DeleteAccountConstants.checkIconSize.height)
            })
        }
    }
    
    // MARK: - SecondPage
    private var secondPageContents: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: DeleteAccountConstants.secondContentsVspacing, content: {
                secondTopcontents
                secondMiddleContents
                Spacer(minLength: DeleteAccountConstants.spacerMin)
            })
        })
        .safeAreaInset(edge: .bottom, content: {
            secondMainButton
        })
    }
    
    /// 상단 계정 이메일 확인
    private var secondTopcontents: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.secondTopVspacing, content: {
            emailConformatoin
            isAccountOwnerConfirmed
        })
    }
    
    /// 상단 이메일 값 확인
    private var emailConformatoin: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.secondEmailVspacing, content: {
            Text(DeleteAccountConstants.secondEmailText)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
            
            TextField("", text: .constant(userEmail))
                .textFieldStyle(.roundedBorder)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
                .disabled(true)
        })
        .padding()
        .background {
            RoundedRectangle(cornerRadius: DeleteAccountConstants.cornerRadius)
                .fill(Color.postBg)
        }
    }
    
    /// 본인 계정 맞는지 체크하는 텍스트
    private var isAccountOwnerConfirmed: some View {
        HStack {
            Text(DeleteAccountConstants.secondOwnerCheckText)
                .font(.Body3_regular)
                .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Button(action: {
                viewModel.isMyAccountCheck.toggle()
            }, label: {
                checkMarkImage(for: viewModel.isMyAccountCheck)
                    .resizable()
                    .frame(width: DeleteAccountConstants.checkIconSize.width, height: DeleteAccountConstants.checkIconSize.height)
            })
        }
    }
    
    /// 탈퇴 사유 체크 필드
    private var secondMiddleContents: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.secondMiddleVspacing, content: {
            secondMiddleTitle
            secondMiddleSelectReason
        })
    }
    
    /// 중간 컨텐츠 탈퇴사유 타이틀
    private var secondMiddleTitle: some View {
        (
            Text(DeleteAccountConstants.secondTitle)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
            
            +
            
            Text(DeleteAccountConstants.secondSubTitle)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        )
    }
    
    /// 기타 사유 입려
    private var secondMiddleSelectReason: some View {
        VStack(alignment: .leading, spacing: DeleteAccountConstants.secondTopVspacing, content: {
            ForEach(DeleteReasonType.allCases, id: \.self) { reason in
                deleteReasonBtn(member: reason)
            }
            
            if viewModel.selectedReasons.contains(.other) {
                TextEditor(text: $viewModel.etcReason)
                    .customStyleTipsEditor(text: $viewModel.etcReason, placeholder: DeleteAccountConstants.placeholder, maxTextCount: DeleteAccountConstants.maxCount, backColor: Color.postBg)
                    .frame(maxWidth: .infinity)
                    .frame(height: DeleteAccountConstants.textEditorSize.height)
                    .focused($isFoucsed)
            }
        })
    }
    
    ///탈퇴 사유 체크 필드 재사용
    private func deleteReasonBtn(member: DeleteReasonType) -> some View {
        HStack(spacing: DeleteAccountConstants.secondDeleteReasonHspacing, content: {
            Button(action: {
                withAnimation {
                    selectedBtnAction(member)
                }
            }, label: {
                checkReasonImage(member)
            })
            
            Text(member.text)
                .font(.Body3_regular)
                .foregroundStyle(Color.gray900)
        })
    }
    
    /// 버튼 선택 시 이미지
    /// - Parameter member: 선택한 버튼의 타입 확인
    /// - Returns: 버튼 반환
    private func checkReasonImage(_ member: DeleteReasonType) -> some View {
        Image(systemName: selectedCondition(member) ? DeleteAccountConstants.checkImage.0 : DeleteAccountConstants.checkImage.1)
            .resizable()
            .frame(width: DeleteAccountConstants.checkBtnSize.width, height: DeleteAccountConstants.checkBtnSize.height)
            .foregroundStyle(selectedCondition(member) ? Color.mainPrimary : Color.gray400)
    }
    
    /// 선택한 버튼이 포함되어 있는지 확인
    /// - Parameter member: 버튼 타입
    /// - Returns: Bool 반환
    private func selectedCondition(_ member: DeleteReasonType) -> Bool {
        return viewModel.selectedReasons.contains(member)
    }
    
    /// 버튼 선택 시 액션
    /// - Parameter member: 선택한 버튼 타입
    /// - Returns: 액션 반환
    private func selectedBtnAction(_ member: DeleteReasonType) -> Void {
        if selectedCondition(member) {
            viewModel.selectedReasons.remove(member)
        } else {
            viewModel.selectedReasons.insert(member)
        }
    }
    
    /// 두 번째 페이지 메인 버튼 이전/탈퇴
    private var secondMainButton: some View {
        HStack {
            generateButton(DeleteAccountConstants.secondBtnBeforText, btnCondition: false, action: {
                viewModel.currentPage = .firstPage
            })
            Spacer()
            generateButton(DeleteAccountConstants.secondBtnCompleteText, btnCondition: true, action: {
                alert.trigger(type: .deleteAccountAlert, showAlert: true, action: {
                    alert.showAlert = false
                    // TODO: - 탈퇴 API 함수 작성
                })
            })
            .disabled(!viewModel.isMyAccountCheck)
        }
    }
    
}

extension DeleteAccountView {
    ///체크 상태에 따른 이미지를 반환하는 함수
    private func checkMarkImage(for isChecked: Bool) -> Image {
        return isChecked ? Image(.check) : Image(.uncheck)
    }
    
    /// 탈퇴 페이지 버튼 생성
    /// - Parameters:
    ///   - text: 버튼 내부 텍스트
    ///   - btnCondition: 버튼 클릭 조건
    ///   - action: 버튼 액션
    /// - Returns: 버튼 뷰 생성
    private func generateButton(_ text: String, btnCondition: Bool, action: @escaping () -> Void) -> some View {
        MainButton(btnText: text, height: DeleteAccountConstants.mainBtnHeight, action: {
            withAnimation {
                action()
            }
        }, color: btnCondition ? Color.mainPrimary : Color.checkBg)
    }
}

#Preview {
    DeleteAccountView(container: DIContainer())
        .environmentObject(DIContainer())
        .environment(AppFlowViewModel())
        .environment(AlertStateModel())
}
