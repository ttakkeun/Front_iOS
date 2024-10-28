//
//  CreateProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

struct CreateProfile: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Button(action: {
            //TODO: - 뷰모델 행동 추가하기
            print("Hello")
        }, label: {
            ZStack(alignment: .top, content: {
                createProfile
                    .padding(.top, 69)
                topImage
            })
            .padding(.top, 28)
        })
    }
    
    private var topImage: some View {
        Icon.togetherPet.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 134, height: 90)
    }
    
    private var createProfile: some View {
        VStack(alignment: .center, spacing: 18, content: {
            Text("새로운 가족 추가하기")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Image(systemName: "plus")
                .resizable()
                .foregroundStyle(Color.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        })
        .frame(width: 213, height: 286)
        .background(Color.mainPrimary)
        .clipShape(.rect(cornerRadius: 20))
        .shadow04()
    }
}

struct CrateProfile_Preview: PreviewProvider {
    static var previews: some View {
        CreateProfile(viewModel: ProfileViewModel(container: DIContainer()))
    }
}
