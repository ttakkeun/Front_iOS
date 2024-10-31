//
//  MakeProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct MakeProfileView: View {
    
    @StateObject var viewModel: MakeProfileViewModel = MakeProfileViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension MakeProfileView {
    
    fileprivate func makeFieldTitle(fieldGroup: FieldGroup) -> HStack<some View> {
        return HStack(content: {
            NameTag(titleText: fieldGroup.title, mustMark: fieldGroup.mustMark)
            
            if fieldGroup.isFieldEnable {
                Icon.check.image
                    .frame(width: 18, height: 18)
            }
        })
    }
    
    func makeNameTextField() -> CustomTextField {
        return CustomTextField(
            keyboardType: .default,
            text: Binding(
                get: { viewModel.requestData.name },
                set: {
                    viewModel.requestData.name = $0
                    viewModel.isNameFieldFilled = !$0.isEmpty
                }
            ),
            placeholder: "반려동물의 이름을 입력해주세요",
            fontSize: 14,
            cornerRadius: 10,
            padding: 23,
            maxWidth: 331,
            maxHeight: 44
        )
    }
}

fileprivate struct FieldGroup {
    let title: String
    let mustMark: Bool
    let isFieldEnable: Bool
}

#Preview {
    MakeProfileView()
}
