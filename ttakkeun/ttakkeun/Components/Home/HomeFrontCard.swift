//
//  HomeFrontCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI
import Kingfisher

/// 홈 프로필 프론트 카드
struct HomeFrontCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    // MARK: - Init
    
    init(viewModel: HomeProfileCardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contents
    }
    
    // MARK: - Components
    
    private var contents: some View {
        VStack(alignment: .center, spacing: 5, content: {
            
            HStack(content: {
                Text("PET CARD")
                    .font(.Body4_extrabold)
                    .foregroundStyle(Color.gray_400)
                
                Spacer()
            })
            .padding(.horizontal, 24)
            .padding(.top, 13)
            
            ProfileImageCard(imageUrl: viewModel.profileData?.result.image)
            
            profileInfor
            
            /* 프로필 카드 체인지 */
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
    
    
    // MARK: - ProfileInfo
    
    /// 프로필 전면부 정보
    @ViewBuilder
    private var profileInfor: some View {
        if let data = viewModel.profileData?.result {
            makeInfor(name: data.name, birth: data.birth)
        } else {
            makeInfor(name: "저장된 이름 불러오기 실패", birth: "저장된 생일 데이터 불러오기 실패")
        }
    }
    
    // MARK: - Function
    
    /// 프로필 정보에 사용되는 뷰 생성 함수
    /// - Parameters:
    ///   - name: 반려동물 이름
    ///   - birth: 반려동물 생일
    /// - Returns: Vstack 뷰
    @ViewBuilder
    private func makeInfor(name: String, birth: String) -> some View {
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
