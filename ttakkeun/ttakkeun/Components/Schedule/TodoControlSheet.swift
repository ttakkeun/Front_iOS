//
//  TodoControlSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/20/24.
//

import SwiftUI

struct TodoControlSheet: View {

    //MARK: - 컴포넌트
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray_300)
                .frame(width: 38, height: 5)
            
            Spacer().frame(height: 20)
            
            VStack(alignment: .center, spacing: 24, content: {
                Text("면봉사기")
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray_900)
                
                /// 수정, 삭제하기 버튼
                correctDeleteBtns
                
                /// 내일 또 하기, 다른날 또 하기, 날짜 바꾸기 버튼
                controlBtns
            })
            .frame(height: 251)
            
            Spacer()
            
        }
        .frame(maxHeight: 300)
        .padding(.horizontal, 10)
    }
    
    private var contentsInSheet: some View {
        VStack(alignment: .center, spacing: 24, content: {
            Text("면봉사기")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray_900)
            
            /// 수정, 삭제하기 버튼
            correctDeleteBtns
            
            /// 내일 또 하기, 다른날 또 하기, 날짜 바꾸기 버튼
            controlBtns
            
            Spacer()
        })
        .frame(width: 309, height: 251)
    }
    
    private var correctDeleteBtns: some View {
        HStack(alignment: .center, spacing: 9, content: {
            makeBtn(btntext: "수정하기", action: {
                //TODO: 버튼 액션(수정하기) 필요
                print("수정하기 버튼 눌림")
            })
            makeBtn(btntext: "삭제하기", action: {
                //TODO: 버튼 액션(삭제하기) 필요
                print("삭제하기 버튼 눌림")
            })
        })
    }
    
    private var controlBtns: some View {
        VStack(alignment: .leading, spacing: 14, content: {
            makeControlBtn(text: "내일 또 하기", image: Icon.tommorrow, action: {
                print("내일 또 하기 버튼 눌림")
                //TODO: 내일 또 하기 버튼 액션 필요
            })
            makeControlBtn(text: "다른날 또 하기", image: Icon.nextTime, action: {
                print("다른날 또 하기 버튼 눌림")
                //TODO: 다른날 또 하기 버튼 액션 필요
            })
            makeControlBtn(text: "날짜 바꾸기", image: Icon.changeDate, action: {
                print("날짜 바꾸기 버튼 눌림")
                //TODO: 날짜 바꾸기 버튼 액션 필요
            })
        })
        .frame(width: 309, alignment: .leading)
    }
    
    //MARK: - Function
    func makeBtn(btntext: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            Text(btntext)
                .frame(width: 150, height: 46)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_900)
                .background(Color.checkBg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .frame(width: 150, height: 46))
        })
    }
    
    func makeControlBtn(text: String, image: Icon, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .center, spacing: 10, content: {
                ///이미지
                image.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                ///텍스트
                Text(text)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
        })
    }
}

//MARK: - Preview
struct TodoControlSheet_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State private var isPickerPresented = false
        
        var body: some View {
            Text("시트뷰 테스트")
                .onTapGesture {
                    isPickerPresented = true
                }
                .sheet(isPresented: $isPickerPresented) {
                    TodoControlSheet()
                        .presentationDetents([.fraction(0.38)])
                        .presentationCornerRadius(30)
                        .padding(.top, 10)
                }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
