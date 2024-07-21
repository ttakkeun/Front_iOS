//
//  CustomAlert.swift
//  ttakkeun
//
//  Created by 한지강 on 7/20/24.
//


import SwiftUI

struct CustomAlert: View {
    @Binding var showPopover: Bool
    
    // TODO:  프로필 생성 뷰의 뷰모델의 yes 액션 함수 필요
    
    var body: some View {
        if showPopover {
                backgroundOpacity
                
                alertWindow
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
        }
    }
    
    
    
    //MARK: - Components
    /// Alert창 전체
    private var alertWindow: some View{
        ZStack{
            VStack(spacing: 26) {
                Text("등록하시겠습니까?")
                    .font(.suit(type: .bold, size: 16))
                
                HStack(spacing: 8, content: {
                    yesBtn
                    NoBtn
                })
            }
            .frame(width: 248,height: 125)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white))
        }
        .background(Color.clear)
    }
    
    
    /// 뒤에 배경을 투명하게
    private var backgroundOpacity: some View {
        Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6)
        .ignoresSafeArea(.all)
            .transition(.opacity)
            .zIndex(0)
    }
    
    
    
    /// 예 버튼
    private var yesBtn: some View {
        Button(action: {
            print("예")
        }, label: {
            Text("예")
                .font(.suit(type: .semibold, size: 14))
                .frame(width: 108, height: 36)
                .foregroundStyle(Color.mainTextColor_Color)
                .background(Color.yesBtn_Color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(width: 108, height: 36)
                )
        })
    }
    
    
    /// 아니요 버튼
    private var NoBtn: some View {
        Button(action: {
            withAnimation(.easeInOut){
                showPopover = false
            }
        }, label: {
            Text("아니오")
                .font(.suit(type: .semibold, size: 14))
                .frame(width: 108, height: 36)
                .foregroundStyle(Color.mainTextColor_Color)
                .background(Color.noBtn_Color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(width: 108, height: 36)
                )
        })
    }
}


//MARK: - Preview
struct CustomAlert_PreView: PreviewProvider {
    
    @State static var check: Bool = true
    
    static var previews: some View {
        CustomAlert(showPopover: $check)
            .previewLayout(.sizeThatFits)
    }
}
