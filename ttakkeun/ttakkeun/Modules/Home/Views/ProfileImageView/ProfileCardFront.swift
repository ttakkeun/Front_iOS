//
//  ProfileCardFront.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct ProfileCardFront: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 5, content: {
            HStack(content: {
                Text("PET CARD")
                    .font(.Body4_extrabold)
                    .foregroundStyle(Color.gray400)
                
                Spacer()
            })
            
            ProfileImage(profileImageUrl: viewModel.profileData?.image)
            
            profileInfo
            
            HStack(content: {
                
                Spacer()
                
                Button(action: {
                    viewModel.isShowFront.toggle()
                }, label: {
                    Icon.changeCard.image
                        .resizable()
                        .frame(width: 16, height: 16)
                })
            })
        })
        
        .padding(.top, 13)
        .padding(.leading, 25)
        .padding(.trailing, 23)
        .padding(.bottom, 20)
        .modifier(CustomCardModifier())
    }
    
    
    
    @ViewBuilder
    private var profileInfo: some View {
        if let data = viewModel.profileData {
            PetInfoTitle(name: data.name, birth: data.birth)
        } else {
            PetInfoTitle(name: "저장된 이름 불러오지 못했습니다.", birth: "저장된 생일 데이터 불러오지 못했습니다.")
        }
    }
}


struct ProfileCardFront_Preview: PreviewProvider {
    static var previews: some View {
        ProfileCardFront(viewModel: HomeProfileCardViewModel())
            .background(Color.mainPrimary)
    }
}
