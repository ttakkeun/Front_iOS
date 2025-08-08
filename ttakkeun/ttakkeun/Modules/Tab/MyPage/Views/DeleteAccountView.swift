//
//  DeleteAccountView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyPageViewModel
    
    @State private var isDeleteAccountMainBtnClicked: Bool = false
    
    ///뷰모델 없어서 임시로 필요한 변수들 state 처리해둠
    @State private var currentPage: Int = 1
    @State private var selectedReasons: Set<String> = []
    @State private var etcReason: String = ""
    @State private var agreementIsChecked: Bool = false
    @State private var myAccountIsChecked: Bool = false
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    
    let reasonList = ["기능 불만족", "앱 내 콘텐츠 부족", "기술적 문제(버그, 오류)", "기기 호환성 문제", "사용자 경험 불편","기타 사유"]
    
    var body: some View {
        ZStack(content: {
            VStack(alignment: .center, spacing: 40, content: {
                CustomNavigation(action: { container.navigationRouter.pop() },
                                 title: "회원 탈퇴",
                                 currentPage: nil)
                
                switch currentPage {
                case 1:
                    checkConfirmTerms
                case 2:
                    inputReason
                default:
                    EmptyView()
                }
            })
//            
//            if isDeleteAccountMainBtnClicked {
//                CustomAlert(alertText: Text("정말로 따끈을 떠나시겠습니까?"), alertSubText: Text("회원님의 소중한 정보는 이용약관에 따라 처리됩니다. \n이대로 탈퇴를 누르신다면 탈퇴를 취소하실 수 없습니다."), alertAction: .init(showAlert: $isDeleteAccountMainBtnClicked, yes: { print("ok") }), alertType: .deleteAccountAlert)
//            }
        })
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: - 1 Page: 유의 사항 확인
    private var checkConfirmTerms: some View {
        VStack(alignment: .center, spacing: 24, content: {
            readConfirmTerms
            
            agreeConfirmTerms
            
            Spacer()
            
            MainButton(btnText: "다음", height: 63, action: {
                withAnimation {
                    currentPage = 2
                }
            }, color: agreementIsChecked ? Color.mainPrimary : Color.checkBg)
            .disabled(!agreementIsChecked)
        })
    }
    
    /// 유의사항
    private var readConfirmTerms: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("회원 탈퇴 전, 유의사항을 확인해주세요.")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ScrollView(content: {
                Text("""
                [회원 탈퇴 시 유의 사항]
                
                1. 데이터 삭제
                    * 회원 탈퇴를 신청하면 사용자의 모든 개인 정보 및 반려동물 프로필 정보, 서비스 이용 내역이 영구적으로 삭제됩니다.
                    * 단, 사용자가 작성한 게시글은 작성자 이름이 가려진 상태로 남아있을 수 있으며, 게시글 내용은 삭제되지 않습니다.
                    * 삭제된 데이터는 복구할 수 없으니 신중히 결정해 주시기 바랍니다.
                2. 서비스 이용 제한 및 재가입
                    * 탈퇴 완료 시 서비스 이용이 중단되며, 관련 정보도 삭제됩니다.
                    * 회원 탈퇴 후 동일한 이메일 주소로 재가입이 가능하지만, 이전에 사용했던 데이터는 복구되지 않으며, 새로운 계정으로 서비스 이용을 시작하게 됩니다.
                3. 재가입
                    * 회원 탈퇴 후에는 동일한 이메일 주소로 재가입이 가능합니다. 다만, 이전 가입 시의 데이터는 유지되지 않으며, 새로운 계정으로 서비스 이용을 시작하게 됩니다.
                """)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray700)
            })
            .frame(width: 315, height: 272, alignment: .leading)
            .padding(.horizontal, 17)
            .padding(.vertical, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .stroke(Color.gray200, lineWidth: 1)
            )
        })
    }
    
    /// 유의사항 동의 체크 필드
    private var agreeConfirmTerms: some View {
        HStack(alignment: .center, spacing: 57, content: {
            Text("탈퇴 시, 위 유의 사항을 확인하였음에 동의합니다.")
                .font(.Body3_regular)
                .foregroundStyle(Color.gray900)
            
            Button(action: {
                agreementIsChecked.toggle()
            }, label: {
                checkmarkImage(for: agreementIsChecked)
                    .resizable()
                    .frame(width: 25, height: 25)
            })
            
        })
    }
    
    //MARK: - 2 Page: 탈퇴 사유 입력
    private var inputReason: some View {
        VStack(alignment: .center, spacing: 52, content: {
            emailConfirm
            
            checkReasons
            
            Spacer()
            
            HStack(alignment: .center, spacing: 10, content: {
                MainButton(btnText: "이전", height: 63, action: {
                    withAnimation {
                        currentPage = 1
                    }
                }, color: Color.answerBg)
                
                MainButton(btnText: "탈퇴하기", height: 63, action: {isDeleteAccountMainBtnClicked.toggle()}, color: myAccountIsChecked ? Color.mainPrimary : Color.checkBg)
                    .disabled(!myAccountIsChecked)
            })
            .frame(width: 351)
        })
    }
    
    ///이메일 확인 필드
    private var emailConfirm: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            VStack(alignment: .leading, spacing: 10, content: {
                Text("보안을 위해, 회원님의 계정 이메일을 확인합니다.")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
                
                //TODO: - 주석 제거 필요
                Text(verbatim: "rwd4533@naver.com")
//                Text("\(UserState.shared.getUserEmail())")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray400)
                    .padding(.leading, 21)
                    .frame(width: 317, height: 45, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .stroke(Color.gray200, lineWidth: 1)
                    )
                    
    
            })
            .padding(.leading, 14)
            .frame(width: 349, height: 97, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.answerBg)
            )
            
            HStack(alignment: .center, spacing: 196, content: {
                Text("본인 계정이 맞습니까?")
                    .font(.Body3_regular)
                    .foregroundStyle(Color.gray900)
                
                Button(action: {
                    myAccountIsChecked.toggle()
                }, label: {
                    checkmarkImage(for: myAccountIsChecked)
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                
            })
        })
    }
    
    /// 탈퇴 사유 체크 필드
    private var checkReasons: some View {
        VStack(alignment: .center, spacing: 18, content: {
            HStack(alignment: .center, spacing: 0) {
                Text("탈퇴사유를 알려주시면 저희한테 큰 도움이 됩니다.")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
                Text("(중복선택가능)")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
            }
            
            reasons
        })
    }
    
    private var reasons: some View {
        
        VStack(alignment: .leading, spacing: 13, content: {
            ForEach(reasonList.indices, id: \.self) { index in
                checkField(id: index, text: reasonList[index])
            }
            
            TextEditor(text: $etcReason)
                .customStyleTipsEditor(text: $etcReason, placeholder: "입력해주세요.", maxTextCount: 200, backColor: Color.postBg)
                .frame(width: 349, height: 75)
        })
        
    }
}

extension DeleteAccountView {
    ///체크 상태에 따른 이미지를 반환하는 함수
    private func checkmarkImage(for isChecked: Bool) -> Image {
        return isChecked ? Icon.check.image : Icon.uncheck.image
    }
    
    ///탈퇴 사유 체크 필드 재사용
    private func checkField(id: Int, text: String) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Button(action: {
                if selectedReasons.contains(text) {
                    selectedReasons.remove(text)
                } else {
                    selectedReasons.insert(text)
                }
            }, label: {
                Image(systemName: selectedReasons.contains(text) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(selectedReasons.contains(text) ? Color.mainPrimary : Color.gray400)
            })
            
            Text(text)
                .font(.Body3_regular)
                .foregroundStyle(Color.gray900)
        }
    }
}

//MARK: - Preview
struct DeleteAccountView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            DeleteAccountView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}

