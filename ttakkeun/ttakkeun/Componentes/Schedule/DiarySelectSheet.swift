//
//  DiarySelectSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/13/24.
//

import SwiftUI

/// 년, 월 선택 시트 뷰
struct DiarySelectSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    @State private var tempDate: Date

    init(selectedDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self._tempDate = State(initialValue: selectedDate.wrappedValue)
    }

    //MARK: - 컴포넌트
    var body: some View {
        VStack {
            /// 확인, 취소 버튼
            HStack {
                Button("취소") {
                    isPresented = false
                }
                Spacer()
                Button("확인") {
                    selectedDate = tempDate
                    isPresented = false
                }
            }
            .padding()
            /// 년도, 월 선택 CustomPickerView 호출
            CustomDatePickerView(selectedDate: $tempDate)
                .frame(maxHeight: 200)
                .clipped()
        }
        .frame(height: UIScreen.main.bounds.height / 2)
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}

//MARK: - Preview
struct DiarySelectSheet_Previews: PreviewProvider {
    static var previews: some View {
        DiarySelectSheet(selectedDate: .constant(Date()), isPresented: .constant(true))
    }
}
