//
//  SelectBtnBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

/// 버튼 선택 박스, 각종 마이페이지 네비게이션 뷰에서 사용
struct SelectBtnBox: View {
   
    // MARK: - Property
    var btnInfo: BtnInfo
    @Binding var isSelected: Bool
    
    // MARK: - Constants
    fileprivate enum SelectedBtnBoxConstants {
        static let btnHeight: CGFloat = 56
        static let btnHorizonPadding: CGFloat = 17
        static let cornerRadius: CGFloat = 10
    }
    
    //MARK: - Init
    /// Description
    /// - Parameters:
    ///   - btnInfo : 해당 버튼에 대한 정보 담은 구조체
    init(btnInfo: BtnInfo, isSelected: Binding<Bool> = .constant(false)) {
        self.btnInfo = btnInfo
        self._isSelected = isSelected
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            isSelected.toggle()
            btnInfo.action()
        }, label: {
            buttonLabel
        })
    }
    
    /// 버튼 내부 라벨
    private var buttonLabel: some View {
        ZStack(alignment: .leading, content: {
            RoundedRectangle(cornerRadius: SelectedBtnBoxConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
                .frame(height: SelectedBtnBoxConstants.btnHeight)
            
            btnContent
                .padding(.horizontal, SelectedBtnBoxConstants.btnHorizonPadding)
        })
    }
    
    @ViewBuilder
    private var btnContent: some View {
        if let date = btnInfo.date {
            dateBtnContent(date)
        } else {
            btnText
        }
    }
    
    /// 글자만 있는 경우 버튼 내부 텍스트
    private var btnText: some View {
        Text(btnInfo.name)
            .font(.Body2_medium)
            .foregroundStyle(Color.gray900)
    }
    
    /// 날짜와 버튼 같이 존재하는 경우 버튼
    /// - Parameter date: 날짜 데이터
    /// - Returns: 버튼 뷰 반환
    private func dateBtnContent(_ date: String) -> some View {
        HStack {
            btnText
            Spacer()
            Text(date)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        }
    }
}

//MARK: - Preview
#Preview {
    SelectBtnBox(btnInfo: BtnInfo(name: "서비스 이용약관", date: nil, action: {print("서비스 이용약관 버튼 눌림")}))
}
