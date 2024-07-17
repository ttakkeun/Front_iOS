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
        rightPetInfo
    }
    
    
    // MARK: - PetInfoContents
    
    /// 오른쪽 펫 정보
    private var rightPetInfo: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            myPetTag
            myPetInfo
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
            .clipShape(.rect(cornerRadius: 20))
            .font(.suit(type: .semibold, size: 10))
            .foregroundStyle(Color.mainTextColor_Color)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.clear)
                    .border(Color.BorderColor_Color)
                    .frame(maxWidth: 90, maxHeight: 24)
            )
            
    }
    
    
    // MARK: - Function
    private func makeInfo(text: String) -> some View {
        Text(text)
            .font(.suit(type: .medium, size: 12))
            .foregroundStyle(Color.mainTextColor_Color)
            .frame(minWidth: 104)
    }
}

struct HomeBackCard_PreView: PreviewProvider {
    static var previews: some View {
        HomeBackCard(viewModel: HomeProfileCardViewModel())
    }
}
