//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/12/24.
//

import SwiftUI

struct MyPageView: View {
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @AppStorage(AppStorageKey.userNickname) var userNickname: String?
    @AppStorage(AppStorageKey.userEmail) var userEmail: String?
    
    @State var viewModel: MyPageViewModel
    @State private var isNickBtnClicked: Bool = false
    @State private var isProfileDeleteBtnClicked: Bool = false
    @State private var isLogoutBtnClicked: Bool = false
    
    // MARK: - Constants
    fileprivate enum MyPageConstants {
        static let contentsVspacing: CGFloat = 37
        static let topContentsVspacing: CGFloat = 17
        static let myProfileVspacing: CGFloat = 6
        static let myProfileHspacing: CGFloat = 12
        static let topBtnHspacing: CGFloat = 13
        static let topBtnVspacing: CGFloat = 15
        static let middleGroupVspacing: CGFloat = 21
        
        static let profileImageSize: CGSize = .init(width: 60, height: 60)
        static let editNicknameBtnSize: CGSize = .init(width: 78, height: 31)
        static let topScrapBtnSize: CGFloat = 96
        
        static let cornerRadius: CGFloat = 40
        
        static let editBtnText: String = "닉네임 수정"
        static let profileImage: String = "person.circle.fill"
        static let userNameText: String = "사용자 닉네임을 가져오지 못했습니다."
        static let emailText: String = "사용자 이메일을 가져오지 못했습니다."
        static let naviTitle: String = "마이페이지"
        static let leftChevron: String = "chevron.backward"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
        self.viewModel.getUserInfo()
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: MyPageConstants.contentsVspacing, content: {
                topContents
                middleContents
                Spacer()
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.top, UIConstants.defaultSafeTop)
            .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
            .customNavigation(title: MyPageConstants.naviTitle, leadingAction: {
                container.navigationRouter.pop()
            }, naviIcon: Image(systemName: MyPageConstants.leftChevron))
        }
        // TODO: - 팝업 창 관련 기능
        
      ////                    if isNickBtnClicked {
      ////                        CustomAlert(alertText: Text("닉네임 수정하기"), alertSubText: Text(UserState.shared.getUserName()), alertAction: .init(showAlert: $isNickBtnClicked, yes: {
      ////                            viewModel.editName(newUsername: viewModel.inputNickname)
      ////                        }), nickNameValue: $viewModel.inputNickname)
      ////                    }
      ////
      ////                    if isLogoutBtnClicked {
      ////                        CustomAlert(alertText: Text("로그아웃 하시겠습니까?"), alertSubText: Text("해당 계정으로 다시 로그인 하신다면 기존에 사용하시던 \n데이터 그대로 다시 이용하실 수 있습니다."), alertAction: .init(showAlert: $isLogoutBtnClicked, yes: { print("ok") }), alertType: .deleteAccountAlert)
      ////                    }
      ////
      ////                    if isProfileDeleteBtnClicked {
      ////                        CustomAlert(alertText: Text("해당 프로필을 삭제하시겠습니까?"), alertSubText: Text("해당 프로필에 저장된 데이터는 모두 삭제됩니다. \n삭제된 데이터는 다시 복원할 수 없습니다."), alertAction: .init(showAlert: $isProfileDeleteBtnClicked, yes: { print("ok") }), alertType: .deleteAccountAlert)
    }
    
    // MARK: - TopContents
    /// 상단 본인 프로필 + tips 그룹 버튼
    private var topContents: some View {
        VStack(alignment: .center, spacing: MyPageConstants.topContentsVspacing, content: {
            profile
            tipsBtns
        })
    }
    
    // MARK: - MyProfile
    /// 프로필 필드(사진, 닉네임, 이메일, 닉네임 수정버튼)
    private var profile: some View {
        HStack(alignment: .center, spacing: MyPageConstants.myProfileHspacing, content: {
            myProfileImage
            myProfileInfo
            Spacer()
            editNicknameBtn
        })
    }
    
    /// 프로필 이미지
    private var myProfileImage: some View {
        Image(systemName: MyPageConstants.profileImage)
            .resizable()
            .frame(width: MyPageConstants.profileImageSize.width, height: MyPageConstants.profileImageSize.height)
            .aspectRatio(contentMode: .fill)
            .tint(Color.gray300)
    }
    
    /// 마이 프로필 정보
    private var myProfileInfo: some View {
        VStack(alignment: .leading, spacing: MyPageConstants.myProfileVspacing, content: {
            Text(userNickname ?? MyPageConstants.userNameText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            Text(verbatim: "\(userEmail ?? MyPageConstants.emailText)")
                .font(.Body4_semibold)
                .foregroundStyle(Color.gray900)
        })
    }
    
    /// 닉네임 수정 버튼
    private var editNicknameBtn: some View {
        Button(action: {
            isNickBtnClicked.toggle()
        }, label: {
            Text(MyPageConstants.editBtnText)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .frame(width: MyPageConstants.editNicknameBtnSize.width, height: MyPageConstants.editNicknameBtnSize.height)
                .background(content: {
                    RoundedRectangle(cornerRadius: MyPageConstants.cornerRadius)
                        .fill(Color.primarycolor300)
                })
        })
    }
    
    /// tips 버튼들(내가 쓴 tips, 내가 스크랩한 tips)
    private var tipsBtns: some View {
        HStack(alignment: .center, spacing: MyPageConstants.topBtnHspacing, content: {
            generateTopButton(.myWriteTips, action: {
                container.navigationRouter.push(to: .myTips)
            })
            generateTopButton(.myScrapTips, action: {
                container.navigationRouter.push(to: .myScrapTips)
            })
        })
    }
    
    private func generateTopButton(_ type: TipsBtnType, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: type.cornerRadius)
                    .fill(Color.white)
                    .stroke(Color.gray200, style: .init())
                    .frame(height: MyPageConstants.topScrapBtnSize)
                
                generateTopBtnContents(type)
            }
        })
    }
    
    /// 버튼 내부 컨텐츠
    /// - Parameter type: 버튼 타입
    /// - Returns: 버튼 컨텐츠 생성
    private func generateTopBtnContents(_ type: TipsBtnType) -> some View {
        VStack(spacing: MyPageConstants.topBtnVspacing, content: {
            Image(type.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: type.imageSize.width, height: type.imageSize.height)
            
            Text(type.text)
                .font(.Body3_semibold)
                .foregroundStyle(Color.black)
        })
    }
    
    // MARK: - MiddleContents
    /// 앱 정보 관련 그룹 박스 모음
    private var middleContents: some View {
        VStack(alignment: .center, spacing: MyPageConstants.middleGroupVspacing, content: {
            MyPageInfoBox(groupType: .appInfo, showVersionInfo: true, actions: [
                .terms: { print("이용약관 및 정책") }
            ])
            MyPageInfoBox(groupType: .usageInfo, actions: [
                .inquiry: { print("문의하기") },
                .report: { print("신고하기") }
            ])
            MyPageInfoBox(groupType: .account, actions: [
                .logout: { print("로그아웃하기") },
                .deleteProfile: { print("프로필 삭제하기") },
                .leave: { print("탈퇴하기") }
            ])
        })
    }
}

//MARK: - Preview
#Preview {
    MyPageView(container: DIContainer())
        .environmentObject(DIContainer())
}
