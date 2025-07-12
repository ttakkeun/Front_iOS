//
//  ProfileCardFront.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct ProfileCardFront: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeProfileCardViewModel
    
    // MARK: - Constants
    fileprivate enum ProfileCardFrontConstants {
        static let bottomAreaHorizonPadding: CGFloat = 19
        static let bottomAreaTopPadding: CGFloat = 13
        static let bottomAreaBottomPadding: CGFloat = 18
        
        static let profileCardHeight: CGFloat = 232
        static let profileVspacing: CGFloat = 10
        
        static let refreshBtnSize: CGFloat = 16
        
        
        static let topTitle: String = "PET CARD"
        static let petProfileNameWarningText: String = "저장된 이름 불러오지 못했습니다"
        static let petProfileBirthWarningText: String = "저장된 생일 데이터 불러오지 못했습니다."
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            bottomArea
            topArea
        }
        .frame(maxWidth: .infinity)
        .frame(height: ProfileCardFrontConstants.profileCardHeight)
        .modifier(CustomCardModifier())
    }
    
    // MARK: - BottomArea
    /// Z스택 아래 영역
    private var bottomArea: some View {
        VStack {
            topTitle
            Spacer()
            bottomRefreshBtn
        }
        .padding(.horizontal, ProfileCardFrontConstants.bottomAreaHorizonPadding)
        .padding(.top, ProfileCardFrontConstants.bottomAreaTopPadding)
        .padding(.bottom, ProfileCardFrontConstants.bottomAreaBottomPadding)
    }
    
    /// 상단 탑 타이틀
    private var topTitle: some View {
        HStack(content: {
            Text(ProfileCardFrontConstants.topTitle)
                .font(.Body3_bold)
                .foregroundStyle(Color.gray400)
            Spacer()
        })
    }
    
    /// 하단 새로고침 버튼
    private var bottomRefreshBtn: some View {
        HStack(content: {
            Spacer()
            Button(action: {
                viewModel.isShowFront.toggle()
            }, label: {
                Image(.changeCard)
                    .resizable()
                    .frame(width: ProfileCardFrontConstants.refreshBtnSize, height: ProfileCardFrontConstants.refreshBtnSize)
            })
        })
    }
    
    @ViewBuilder
    private var profileInfo: some View {
        if let data = viewModel.profileData {
            PetInfoTitle(name: data.name, birth: data.birth)
        } else {
            PetInfoTitle(name: ProfileCardFrontConstants.petProfileNameWarningText, birth: ProfileCardFrontConstants.petProfileBirthWarningText)
        }
    }
    
    // MARK: - TopArea
    private var topArea: some View {
        VStack(spacing: ProfileCardFrontConstants.profileVspacing, content: {
            ProfileImage(profileImageUrl: viewModel.profileData?.image)
            profileInfo
        })
    }
}


struct ProfileCardFront_Preview: PreviewProvider {
    static var previews: some View {
        ProfileCardFront(viewModel: HomeProfileCardViewModel(container: DIContainer()))
            .previewLayout(.sizeThatFits)
    }
}
