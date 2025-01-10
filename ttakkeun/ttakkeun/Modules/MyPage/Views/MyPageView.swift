//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/12/24.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @StateObject var viewModel: MyPageViewModel
    @State private var isNickBtnClicked: Bool = false
    @State private var isProfileDeleteBtnClicked: Bool = false
    @State private var isLogoutBtnClicked: Bool = false
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
        self.viewModel.getUserInfo()
    }
    
    var body: some View {
        Group {
            if !viewModel.isLoading {
                ZStack(content: {
                    VStack(alignment: .center, spacing: 37, content: {
                        CustomNavigation(action: { container.navigationRouter.pop() },
                                         title: "마이페이지",
                                         currentPage: nil)
                        
                        myInfo
                        
                        bottomMyPageBoxGroup
                        
                        Spacer()
                    })
                    
                    if isNickBtnClicked {
                        CustomAlert(alertText: Text("닉네임 수정하기"), alertSubText: Text(UserState.shared.getUserName()), alertAction: .init(showAlert: $isNickBtnClicked, yes: {
                            viewModel.editName(newUsername: viewModel.inputNickname)
                        }), nickNameValue: $viewModel.inputNickname)
                    }
                    
                    if isLogoutBtnClicked {
                        CustomAlert(alertText: Text("로그아웃 하시겠습니까?"), alertSubText: Text("해당 계정으로 다시 로그인 하신다면 기존에 사용하시던 \n데이터 그대로 다시 이용하실 수 있습니다."), alertAction: .init(showAlert: $isLogoutBtnClicked, yes: { print("ok") }), alertType: .deleteAccountAlert)
                    }
                    
                    if isProfileDeleteBtnClicked {
                        CustomAlert(alertText: Text("해당 프로필을 삭제하시겠습니까?"), alertSubText: Text("해당 프로필에 저장된 데이터는 모두 삭제됩니다. \n삭제된 데이터는 다시 복원할 수 없습니다."), alertAction: .init(showAlert: $isProfileDeleteBtnClicked, yes: { print("ok") }), alertType: .deleteAccountAlert)
                    }
                })
            } else {
                VStack {
                    
                    Spacer()
                    
                    ProgressView(label: {
                        LoadingDotsText(text: "잠시만 기다려주세요")
                    })
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: - Compoents
    
    private var myInfo: some View {
        VStack(alignment: .center, spacing: 17, content: {
            profile
            tipsBtns
        })
    }
    
    /// 프로필 필드(사진, 닉네임, 이메일, 닉네임 수정버튼)
    private var profile: some View {
        HStack(alignment: .center, spacing: 12, content: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .aspectRatio(contentMode: .fill)
                .tint(Color.gray300)
            
            VStack(alignment: .leading, spacing: 6,content: {
                
                if let userInfo = viewModel.userInfo {
                    Text(userInfo.username ?? "사용자 닉네임을 가져오지 못했습니다.")
                        .font(.H4_bold)
                        .foregroundStyle(Color.gray900)
                    
                    Text(verbatim: "\(userInfo.email ?? "사용자 이메일을 가져오지 못했습니다.")")
                        .font(.Body4_semibold)
                        .foregroundStyle(Color.gray900)
                }
            })
            
            Spacer()
            
            Button(action: {
                isNickBtnClicked.toggle()
            }, label: {
                Text("닉네임 수정")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
                    .frame(width: 78, height: 31)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.primarycolor300)
                    })
            })
        })
        .frame(width:348, height: 60)
    }
    
    /// tips 버튼들(내가 쓴 tips, 내가 스크랩한 tips)
    private var tipsBtns: some View {
        HStack(alignment: .center, spacing: 13, content: {
            makeButton(text: "내가 쓴 tips", image: Icon.tips.image, action: {container.navigationRouter.push(to: .myTips)})
            makeButton(text: "내가 스크랩한 tips", image: Icon.scrap.image, action: {container.navigationRouter.push(to: .myScrapTips)})
        })
    }
    
    /// 아래 myPage 기능들
    private var bottomMyPageBoxGroup: some View {
        VStack(alignment: .center, spacing: 21,content: {
            ///앱 정보 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "앱 정보",
                boxBtn: [
                    BtnInfo(name: "이용약관 및 정책", date: nil, action: { container.navigationRouter.push(to: .appInfo) })
                ]
            ), versionInfo: "v1.0.0")
            
            ///이용정보 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "이용 정보",
                boxBtn: [
                    BtnInfo(name: "문의하기", date: nil, action: { container.navigationRouter.push(to: .inquireBtn) })
                ]
            ))
            
            ///계정 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "계정",
                boxBtn: [
                    BtnInfo(name: "로그아웃하기",
                            date: nil,
                            action: {
                                viewModel.logout { result in
                                    switch result {
                                    case .success(_):
                                        container.navigationRouter.pop()
                                        appFlowViewModel.logout()
                                    case .failure(_):
                                        print("로그아웃 실패")
                                    }
                                }
                              
                            }),
                    BtnInfo(name: "프로필 삭제하기",
                            date: nil,
                            action: {
                                viewModel.deleteProfile()
                                container.navigationRouter.pop()
                                appFlowViewModel.deleteProfile()
                            }),
                    BtnInfo(name: "탈퇴하기", date: nil, action: { print("탈퇴 버튼 눌림") })
                ]
            ))
        })
    }
}

//MARK: - Function
extension MyPageView {
    /// 내가 쓴 tips, 스크랩한 tips 버튼 커스텀
    private func makeButton(text: String, image: Image , action: @escaping () -> Void) -> some View {
        
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 13, content: {
                image
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(text)
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
            })
            .frame(width: 167, height: 96)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .stroke(Color.gray200, lineWidth: 1)
            )
        })
    }
}

//MARK: - Preview
struct MyPageView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyPageView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
