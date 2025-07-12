//
//  ProfileCardBack.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct ProfileCardBack: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeProfileCardViewModel
    
    // MARK: - Constants
    fileprivate enum ProfileCardConstants {
        static let leftPetVspacing: CGFloat = 14
        static let rightPetVspacing: CGFloat = 5
        static let rightHspacing: CGFloat = 24
        
        static let refreshSize: CGFloat = 16
        static let tagFontSize: CGFloat = 10
        static let pencilSize: CGFloat = 25
        static let leftImageSize: CGFloat = 86
        static let profileCardHeight: CGFloat = 232
        
        static let tagVerticalPadding: CGFloat = 6
        static let tagHorizonPadding: CGFloat = 11
        static let rightTopPadding: CGFloat = 10
        static let bottomAreaHorizonPadding: CGFloat = 19
        static let bottomAreaTopPadding: CGFloat = 17
        static let bottomAreaBottomPadding: CGFloat = 18
        
        static let topAreaOffsetY: CGFloat = 10
        static let cornerRadius: CGFloat = 40
        
        static let pencilName: String = "pencil.circle"
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            bottomArea(data: viewModel.profileData)
            if let data = viewModel.profileData {
                topArea(data: data)
            } else {
                ProgressView()
                    .controlSize(.regular)
            }
        }
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .frame(maxWidth: .infinity)
        .frame(height: ProfileCardConstants.profileCardHeight)
        .modifier(CustomCardModifier())
    }
    
    // MARK: - BottomArea
    private func bottomArea(data: HomeProfileResponseData?) -> some View {
        VStack {
            if let data = data {
                myPetTag(data: data)
            }
            Spacer()
            refreshButton
        }
        .padding(.top, ProfileCardConstants.bottomAreaTopPadding)
        .padding(.bottom, ProfileCardConstants.bottomAreaBottomPadding)
    }
    
    private var refreshButton: some View {
        HStack(content: {
            Spacer()
            
            Button(action: {
                viewModel.isShowFront.toggle()
            }, label: {
                Image(.changeCard)
                    .resizable()
                    .frame(width: ProfileCardConstants.refreshSize, height: ProfileCardConstants.refreshSize)
            })
        })
    }
    
    @ViewBuilder
    private func myPetTag(data: HomeProfileResponseData) -> some View {
        HStack {
            Text("내 \(data.type.toKorean()) 정보")
                .font(.suit(type: .semibold, size: ProfileCardConstants.tagFontSize))
                .foregroundStyle(Color.gray900)
                .padding(.vertical, ProfileCardConstants.tagVerticalPadding)
                .padding(.horizontal, ProfileCardConstants.tagHorizonPadding)
                .background {
                    RoundedRectangle(cornerRadius: ProfileCardConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray900)
                }
            
            Spacer()
            
            Button(action: {
                viewModel.goToEditPetProfile()
            }, label: {
                Image(systemName: ProfileCardConstants.pencilName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: ProfileCardConstants.pencilSize, height: ProfileCardConstants.pencilSize)
                    .foregroundStyle(Color.black)
            })
        }
    }
    
    // MARK: - TopArea
    
    private func topArea(data: HomeProfileResponseData) -> some View {
        HStack(alignment: .top, spacing: ProfileCardConstants.rightHspacing, content: {
            leftInfo(data: data)
            rightInfo(data: data)
        })
        .offset(y: ProfileCardConstants.topAreaOffsetY)
    }
    
    private func leftInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .center, spacing: ProfileCardConstants.leftPetVspacing, content: {
            ProfileImage(profileImageUrl: data.image, imageSize: ProfileCardConstants.leftImageSize)
            
            PetInfoTitle(name: data.name, birth: data.birth)
        })
    }
    
    private func rightInfo(data: HomeProfileResponseData) -> some View {
        VStack(alignment: .leading, spacing: ProfileCardConstants.rightPetVspacing, content: {
            makeRightInfo(text: "상태 : \(data.neutralization ? "중성화 완료" : "중성화 미완료")")
            makeRightInfo(text: "품종: \(data.variety)")
        })
        .padding(.top, ProfileCardConstants.rightTopPadding)
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
