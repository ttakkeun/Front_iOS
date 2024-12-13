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
        VStack(alignment: .leading, spacing: 17, content: {
            if let data = viewModel.profileData {
                myPetTag(data: data)
                
                myPetInfo(data: data)
                
            } else {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    ProgressView(label: { LoadingDotsText(text: "데이터를 받아오지 못했습니다") })
                        .controlSize(.regular)
                    
                    Spacer()
                }
                
                Spacer()
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
        .frame(width: 320, height: 232)
        .padding(.top, 13)
        .padding(.leading, 25)
        .padding(.bottom, 23)
        .padding(.trailing, 18)
        .modifier(CustomCardModifier())
        
    }
    
    @ViewBuilder
    private func myPetTag(data: HomeProfileResponseData) -> some View {
        HStack(spacing: 5) {
            Text("내 \(data.type.toKorean()) 정보")
                .font(.suit(type: .semibold, size: 10))
                .foregroundStyle(Color.gray900)
                .frame(width: 69, height: 16)
                .padding(.vertical, 6)
                .padding(.horizontal, 11)
                .background {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.clear)
                        .stroke(Color.gray900)
                }
            
            Spacer()
            
            Button(action: {
                viewModel.goToEditPetProfile()
            }, label: {
                Image(systemName: "pencil.circle")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.black)
            })
        }
    }
    
    private func myPetInfo(data: HomeProfileResponseData) -> some View {
        HStack(alignment: .top, spacing: 24, content: {
            leftInfo(data: data)
            rightInfo(data: data)
        })
        .frame(width: 320)
    }
    
    @ViewBuilder
    private func leftInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .center, spacing: 14, content: {
            ProfileImage(profileImageUrl: data.image, imageSize: 86)
            
            PetInfoTitle(name: data.name, birth: data.birth)
        })
    }
    
    private func rightInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .leading, spacing: 5, content: {
            makeRightInfo(text: "상태 : \(data.neutralization ? "중성화 완료" : "중성화 미완료")")
            makeRightInfo(text: "품종: \(data.variety)")
        })
        .padding(.top, 10)
    }
    
    func makeRightInfo(text: String) -> some View {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
    }
}

struct ProfileCardBack_Preview: PreviewProvider {
    static var previews: some View {
        ProfileCardBack(viewModel: HomeProfileCardViewModel(container: DIContainer()))
    }
}
