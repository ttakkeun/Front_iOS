//
//  HomeBackCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// 홈프로필 백카드
struct HomeBackCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    init(viewModel: HomeProfileCardViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        contents
    }
    
    // MARK: - Contents
    @ViewBuilder
    private var contents: some View {
        VStack(alignment: .center, spacing: 29, content: {
            if let data = viewModel.profileData?.result {
                
                HStack(content: {
                    Text("저는 이런 \(data.type.toKorean())에요!")
                        .font(.Body4_extrabold)
                        .foregroundStyle(Color.gray_400)
                    Spacer()
                })
                
                petInfoGroup
                
                HStack(content: {
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.isShowFront.toggle()
                    }, label: {
                        Icon.changeCard.image
                            .fixedSize()
                    })
                })
            } else {
                ProgressView()
            }
        })
        .padding(.top, 15)
        .padding(.leading, 16)
        .padding(.bottom, 20)
        .padding(.trailing, 18)
        .frame(width: 354, height: 260)
        .background(Color.white.opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
        .shadow02()
        .transition(.blurReplace)
    }
    
    /// 펫 정보
    private var petInfoGroup: some View {
        HStack(alignment: .center, spacing: 32, content: {
            leftPetInfo
            rightPetInfo
        })
        .frame(height: 132)
    }
    
    // MARK: - LeftPetContents
    /// 왼쪽 프로필과 펫 이름, 생일 정보
    private var leftPetInfo: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ProfileImageCard(imageUrl: viewModel.profileData?.result.image, imageSize: 86, canEdit: false)
            petName
        })
        .frame(width: 86)
    }
    
    /// 펫 이름과 생일 정보
    @ViewBuilder
    private var petName: some View {
        if let data = viewModel.profileData?.result {
            makeLeftInfor(name: data.name, birth: data.birth)
        }
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
            if let data = viewModel.profileData?.result {
                makeRightInfo(text: "상태: \(data.neutralization ? "중성화 완료" : "중성화 미완료")")
                makeRightInfo(text: "품종: \(data.variety)")
            }
        })
    }
    
    /// 상단 펫 태그
    @ViewBuilder
    private var myPetTag: some View {
        if let data = viewModel.profileData?.result {
            Text("내 \(data.type.toKorean()) 정보")
                .frame(maxWidth: 90, maxHeight: 24)
                .clipShape(.rect(cornerRadius: 25))
                .font(.suit(type: .semibold, size: 10))
                .foregroundStyle(Color.gray_900)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.clear)
                        .stroke(Color.primarycolor700)
                )
        }
    }
    
    
    // MARK: - Function
    private func makeRightInfo(text: String) -> some View {
        Text(text)
            .font(.suit(type: .medium, size: 12))
            .foregroundStyle(Color.gray_900)
    }
    
    private func makeLeftInfor(name: String, birth: String) -> some View {
        VStack(alignment: .center, spacing: 2, content: {
            Text(name)
                .frame(maxWidth: 190)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_900)
            
            Text(viewModel.formattedData(from: birth))
                .font(.Detail1_bold)
                .foregroundStyle(Color.gray_400)
        })
        .padding(.top, 10)
    }
    
    
}

struct HomeBackCard_PreView: PreviewProvider {
    static var previews: some View {
        HomeProfileCard(viewModel: HomeProfileCardViewModel(), petId: 1)
            .previewLayout(.sizeThatFits)
    }
}
