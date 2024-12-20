//
//  SelectBtnBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

struct SelectBtnBox: View {
   
    var btnInfo: BtnInfo
    @Binding var isSelected: Bool
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - btnInfo : 해당 버튼에 대한 정보 담은 구조체
    init(btnInfo: BtnInfo, isSelected: Binding<Bool> = .constant(false)) {
        self.btnInfo = btnInfo
        self._isSelected = isSelected
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            btnInfo.action()
        }, label: {
            HStack(alignment: .center, content: {
                Text(btnInfo.name)
                    .font(.Body2_medium)
                    .foregroundStyle(Color.gray900)
                    .lineLimit(1) // 한 줄만 표시
                        .truncationMode(.tail) // 길어지면 ...으로 축약
                
                Spacer()
                
                if let date = btnInfo.date {
                    Text(date)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray400)
                }
            })
            .frame(width:314, height: 20)
            .padding(18)
        })
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.mainPrimary : Color.clear)
                .stroke(Color.gray200, lineWidth: 1)
        }

    }
}

//MARK: - Preview
struct SelectBtnBox_Preview: PreviewProvider {
    static var previews: some View {
    
        SelectBtnBox(btnInfo: BtnInfo(name: "서비스 이용약관", date: "24.01.01", action: {print("서비스 이용약관 버튼 눌림")}))
            .previewLayout(.sizeThatFits)
    }
}
