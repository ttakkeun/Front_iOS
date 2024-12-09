//
//  SelectBtnBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

struct SelectBtnBox: View {
    
    
    var title: String
    var date: String?
    var action: () -> Void
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - title: 버튼 텍스트
    ///   - action: 버튼 동작 액션
    ///   - date: 버튼 텍스트 옆에 날짜 텍스트(선택사항)
    init(title: String, action: @escaping () -> Void, date: String? = nil) {
        self.title = title
        self.action = action
        self.date = date
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .center, content: {
                Text(title)
                    .font(.Body2_medium)
                    .foregroundStyle(Color.gray900)
                
                Spacer()
                
                if let date = date {
                    Text(date)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray400)
                }
            })
            .padding(.horizontal, 17)
            .frame(width:349, height: 56)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.gray200, lineWidth: 1)
        )
    }
}

//MARK: - Preview
struct SelectBtnBox_Preview: PreviewProvider {
    static var previews: some View {
        SelectBtnBox(title: "서비스 이용 약관", action: {print("서비스 이용약관 버튼 눌림")})
            .previewLayout(.sizeThatFits)
    }
}
