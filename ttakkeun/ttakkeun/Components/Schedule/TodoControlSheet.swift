//
//  TodoControlSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/20/24.
//

import SwiftUI

struct TodoControlSheet: View {
    let isChecked: Bool
    
    //MARK: - 컴포넌트
    var body: some View {
         VStack {
             Capsule()
                 .fill(Color.gray_300)
                 .frame(width: 38, height: 5)
                 .padding(.top, 5)
                 .padding(.bottom, 15)
             
             contentsInSheet
             
             Spacer()
         }
         .frame(maxHeight: 300)
         .padding(.horizontal, 10)
     }
     
    ///시트 내부 모든 내용
     private var contentsInSheet: some View {
         VStack(alignment: .center, spacing: 24, content: {
             Text("면봉사기")
                 .font(.Body2_semibold)
                 .foregroundStyle(Color.gray_900)
             
             /// 수정, 삭제하기 버튼
             correctDeleteBtns
             
             /// 체크 상태에 따른 버튼 구성
             if isChecked {
                 controlButtonsForChecked
             } else {
                 controlButtonsForUnchecked
             }
             
         })
         .frame(maxWidth: 309, maxHeight: .infinity)
         .padding(.bottom, isChecked ? 0 : 40)
     }
    
    /// 수정하기, 삭제하기 버튼
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
    
    /// 투두가 체크가 된 상태일때 표시되는 컨트롤 버튼들
    private var controlButtonsForChecked: some View {
        VStack(alignment: .leading, spacing: 14) {
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
        }
        .frame(width: 309, alignment: .leading)
    }
    
    /// 투두가 체크가 안 된 상태일때 표시되는 컨트롤 버튼들
    private var controlButtonsForUnchecked: some View {
        VStack(alignment: .leading, spacing: 14) {
            makeControlBtn(text: "내일 하기", image: Icon.tommorrow, action: {
                print("내일 하기 버튼 눌림")
                //TODO: 내일하기 버튼 액션 필요
            })
            makeControlBtn(text: "날짜 바꾸기", image: Icon.changeDate, action: {
                print("날짜 바꾸기 버튼 눌림")
                //TODO: 날짜 바꾸기 버튼 액션 필요
            })
        }
        .frame(width: 309, alignment: .leading)
    }
    
    //MARK: - Function
    /// 수정하기/삭제하기 버튼 재활용을 위한 함수
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
    
    /// 내일 (또) 하기, 다른날 (또) 하기, 날짜 바꾸기 버튼 재활용을 위한 함수
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


// MARK: - Preview
struct TodoControlSheet_Preview: PreviewProvider {
    static var previews: some View {
        TodoCard(partItem: .claw)
            .previewLayout(.sizeThatFits)
    }
}
