//
//  CreateProfileView.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import SwiftUI

struct CreateProfileView: View {
    
    
    var body: some View {
        VStack {
            
            //TODO: - 프로필 사진 등록
            ///우선 그냥 동그라미 넣어둠
            Circle()
                .fill(Color.black)
                .frame(width: 120, height: 120)
            
            Spacer().frame(height: 21)
            
            infoField
            
            Spacer().frame(height: 72)
            
            MainButton(btnText: "등록하기", width: 330, height: 56, action: {print("프로필 등록됨")}, color: .primaryColor_Main)
        }
    }
    
    ///정보 입력 필드
    private var infoField: some View {
        VStack(alignment: .center, spacing: 19, content: {
            nameField
            typeField
            varietyField
            birthField
            neutralizationField
        })
    }
    
    
    
    /// 이름 name tag + text field
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            MakeProfileNameTag(titleText: "이름", mustMark: true)
            
            @State var text: String = ""
            
            CustomTextField(text: $text, placeholder: "반려동물의 이름을 입력해주세요", fontSize: 14, cornerRadius: 10, padding: 23, showGlass: false, maxWidth: 331, maxHeight: 44)
        })
        .frame(width: 331, height: 78, alignment: .leading)
    }
    
    /// 동물 종류(강아지/고양이) name tag + toggle button
    private var typeField: some View {
        VStack(alignment: .center, spacing: 10, content: {
            MakeProfileNameTag(titleText: "반려", mustMark: true)
            MakeProfileButtonCustom(firstText: "강아지", secondText: "고양이", leftAction: {print("강아지")}, rightAction: {print("고양이")})
        })
        .frame(width: 331, height: 78)
    }
    
    /// 동물 품종 name tag + text field
    private var varietyField: some View {
        VStack(alignment: .center, spacing: 10, content: {
            MakeProfileNameTag(titleText: "품종", mustMark: true)
            
            @State var text: String = ""
            
            CustomTextField(text: $text, placeholder: "반려동물의 품종을 입력해주세요.", fontSize: 14, cornerRadius: 10, padding: 23, showGlass: false, maxWidth: 331, maxHeight: 44)
        })
        .frame(width: 331, height: 80)
    }
    
    /// 생년월일 name tag + text field
    private var birthField: some View {
        VStack(alignment: .center, spacing: 10, content: {
            MakeProfileNameTag(titleText: "생년월일", mustMark: false)
            
            //TODO: 생년 월일 선택하는 피커 만들어야 함!
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 330, height: 44)
                
        })
    }
    
    /// 중성화 여부 name tag + text field
    private var neutralizationField: some View {
        VStack(alignment: .center, spacing: 10, content: {
            MakeProfileNameTag(titleText: "중성화여부", mustMark: true)
            MakeProfileButtonCustom(firstText: "예", secondText: "아니오", leftAction: {print("중성화 예")}, rightAction: {print("중성화 아니오")})
        })
        .frame(width: 331, height: 80)
    }
}


//MARK: - Preview
struct CreateProfileView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            CreateProfileView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}

