//
//  CreateProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

/// 프로필뷰에서 프로필 추가로 넘어가는 카드
struct CreateProfileCard: View {
    
    // MARK: - Property
    @Binding var showFullScreen: Bool
    
    // MARK: - Constants
    fileprivate enum CreateProfileCardConstants {
        static let mainTopPadding: CGFloat = 28
        static let profileVspacing: CGFloat = 18
        static let profileDefaultOffset: CGFloat = 69
        
        static let profileImageWidth: CGFloat = 132
        static let profileImageHeight: CGFloat = 90
        static let profileCardWidth: CGFloat = 213
        static let profileCardHeight: CGFloat = 286
        
        static let plustImageSize: CGFloat = 12
        
        static let cornerRadius: CGFloat = 20
        
        static let profileText: String = "새로운 가족 추가하기"
        static let profilePlustImage: String = "plus"
    }
    
    // MARK: - Init
    init(showFullScreen: Binding<Bool>) {
        self._showFullScreen = showFullScreen
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            showFullScreen.toggle()
        }, label: {
            ZStack(alignment: .top, content: {
                profileDefault
                profileImage
            })
            .padding(.top, CreateProfileCardConstants.mainTopPadding)
        })
    }
    
    /// 상단 추가 버튼 전용 이미지
    private var profileImage: some View {
        Icon.togetherPet.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CreateProfileCardConstants.profileImageWidth, height: CreateProfileCardConstants.profileImageHeight)
    }
    
    /// 프로필 기본 카드 배경
    private var profileDefault: some View {
        VStack(alignment: .center, spacing: CreateProfileCardConstants.profileVspacing, content: {
            Text(CreateProfileCardConstants.profileText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Image(systemName: CreateProfileCardConstants.profilePlustImage)
                .resizable()
                .foregroundStyle(Color.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: CreateProfileCardConstants.plustImageSize, height: CreateProfileCardConstants.plustImageSize)
        })
        .frame(width: CreateProfileCardConstants.profileCardWidth, height: CreateProfileCardConstants.profileCardHeight)
        .background {
            RoundedRectangle(cornerRadius: CreateProfileCardConstants.cornerRadius)
                .fill(Color.mainPrimary)
                .shadow04()
        }
        .padding(.top, CreateProfileCardConstants.profileDefaultOffset)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CreateProfileCard(showFullScreen: .constant(true))
}
