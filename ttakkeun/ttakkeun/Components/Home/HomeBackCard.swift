//
//  HomeBackCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import SwiftUI

/// 홈프로필 백카드
struct HomeBackCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    
    var body: some View {
        contents
    }
    
    // MARK: - Contents
    
    private var contents: some View {
        VStack(alignment: .center, spacing: 29, content: {
            
            HStack(content: {
                Text("저는 이런 고양이에요!")
                    .font(.suit(type: .medium, size: 12))
                    .foregroundStyle(Color.subTextColor_Color)
                
                Spacer()
            })
            .padding(.horizontal, 24)
            .padding(.top, 13)
            
            petInfoGroup
            
            HStack(content: {
                
                Spacer()
                
                Button(action: {
                    viewModel.isChangeCard = true
                }, label: {
                    Icon.changeCard.image
                        .fixedSize()
                })
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        })
        .frame(width: 354, height: 240)
        .background(Color.white.opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
        .shadow02()
    }
    
    private var petInfoGroup: some View {
        HStack(alignment: .center, spacing: 32, content: {
            leftPetInfo
            rightPetInfo
        })
        .frame(maxWidth: 223, maxHeight: 129)
    }
    
    // MARK: - LeftPetContents
    private var leftPetInfo: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ProfileImageCard(imageUrl: viewModel.profileData?.imageUrl ?? "https://i.namu.wiki/i/bhqkJhfV1K2tE5mkPZ2XqlFKy0UDZhMlU77WitL24TX-VEGWZJ4MYctbK91UhM8K27Hzsg3do52gQ_IL5IKGFF5rN1wZaSua966ChAmukooR783zUxG-qiLrEZzBIPgbwjJ_UUh9XBppDzDFLi1l4A.webp", imageSize: 86, canEdit: false)
            petName
            
        })
    }
    
    private var petName: some View {
            VStack(alignment: .center, spacing: 2, content: {
                
                Text(viewModel.profileData?.name ?? "도라에몽")
                    .frame(maxWidth: 190)
                    .font(.suit(type: .medium, size: 14))
                    .foregroundStyle(Color.black)
                
                Text(viewModel.profileData?.date ?? "2024.07.17")
                    .font(.suit(type: .bold, size: 10))
                    .foregroundStyle(Color.subProfileColor_Color)
            })
            .padding(.top, 10)
    }
    
    
    // MARK: - RightPetContents
    
    /// 오른쪽 펫 정보
    private var rightPetInfo: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Spacer()
            
            myPetTag
            myPetInfo
            
            Spacer()
        })
    }
    
    
    /// 카드 뒷면 펫 정보
    private var myPetInfo: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            makeInfo(text: "특징: 단모종")
            makeInfo(text: "상태: 중성화 완료")
            makeInfo(text: "품종: 코리안쇼트헤어")
        })
    }
    
    /// 상단 펫 태그
    private var myPetTag: some View {
        Text("내 고양이 정보")
            .frame(maxWidth: 90, maxHeight: 24)
            .clipShape(.rect(cornerRadius: 25))
            .font(.suit(type: .semibold, size: 10))
            .foregroundStyle(Color.mainTextColor_Color)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.BorderColor_Color)
            )
    }
    
    
    // MARK: - Function
    private func makeInfo(text: String) -> some View {
        Text(text)
            .font(.suit(type: .medium, size: 12))
            .foregroundStyle(Color.mainTextColor_Color)
    }
}

struct HomeBackCard_PreView: PreviewProvider {
    static var previews: some View {
        HomeBackCard(viewModel: HomeProfileCardViewModel())
    }
}
