//
//  ProfileCardBack.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct ProfileCardBack: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 29, content: {
            if let data = viewModel.profileData {
                myPetTag(data: data)
                
                myPetInfo(data: data)
                
            } else {
                
                Spacer()
                
                ProgressView()
                    .frame(width: 120, height: 120)
                
                
            }
            
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
        .padding(.top, 15)
        .padding(.leading, 16)
        .padding(.bottom, 20)
        .padding(.trailing, 18)
        .modifier(CustomCardModifier())
    }
    
    @ViewBuilder
    private func myPetTag(data: HomeProfileResponseData) -> some View {
        HStack(spacing: 8) {
            Text("내 \(data.type.toKorean()) 정보")
                .frame(maxWidth: 90, maxHeight: 24)
                .clipShape(.rect(cornerRadius: 25))
                .font(.suit(type: .semibold, size: 10))
                .foregroundStyle(Color.gray900)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.clear)
                        .stroke(Color.primarycolor700)
                )
            
            Icon.pencil.image
                .renderingMode(.template)
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.black)
            
            Spacer()
        }
    }
    
    private func myPetInfo(data: HomeProfileResponseData) -> some View {
        HStack(alignment: .center, spacing: 32, content: {
            leftInfo(data: data)
            rightInfo(data: data)
        })
        .frame(height: 132)
    }
    
    @ViewBuilder
    private func leftInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .center, spacing: 17, content: {
            ProfileImage(profileImageUrl: data.image, imageSize: 86)
            
            PetInfoTitle(name: data.name, birth: data.birth)
        })
    }
    
    private func rightInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .leading, spacing: 5, content: {
            makeRightInfo(text: "상태 : \(data.neutralization ? "중성화 완료" : "중성화 미완료")")
            makeRightInfo(text: "품종: \(data.variety)")
        })
    }
    
    func makeRightInfo(text: String) -> some View {
        Text(text)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray900)
    }
}

struct ProfileCardBack_Preview: PreviewProvider {
    static var previews: some View {
        ProfileCardBack(viewModel: HomeProfileCardViewModel())
    }
}
