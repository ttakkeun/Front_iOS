//
//  TodoOptionSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct TodoOptionSheetView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 30, content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            mainContents
        })
        .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
        .frame(width: 394, height: 340)
        .border(Color.red)
    }
    
    private var mainContents: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            
            title
            
            topButtonGroup
            
            bottomButtonGroup
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 40, bottom: 47, trailing: 42))
    }
    
    private var title: some View {
        HStack(content: {
            Spacer()
            
            Text("면봉 사기")
                .font(.Body2_medium)
                .foregroundStyle(Color.gray900)
            
            Spacer()
        })
    }
    
    private var topButtonGroup: some View {
        HStack(spacing: 9, content: {
            ForEach(TodoOptionBtn.allCases, id: \.self) { type in
                optionButton(type: type, action: {
                    buttonAction(type)
                })
            }
        })
    }
    
    private var bottomButtonGroup: some View {
        VStack(alignment: .leading, spacing: 14, content: {
            ForEach(TodoActionBtn.allCases, id: \.self) { type in
                bottomButton(type, action: {
                    bottomButtonAction(type)
                })
            }
        })
    }
}

// MARK: - TopButtonFunction

extension TodoOptionSheetView {
    func optionButton(type: TodoOptionBtn, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            Text(type.rawValue)
                .font(.Body3_medium)
                .foregroundStyle(type == .modify ? Color.gray900 : Color.removeBtn)
                .padding(.vertical, 15)
                .padding(.horizontal, 51)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(setColor(type))
                }
        })
    }
    
    func setColor(_ type: TodoOptionBtn) -> Color {
        switch type {
        case .modify:
            return Color.scheduleBg
        case .remove:
            return Color.postBg
        }
    }
    
    func buttonAction(_ type: TodoOptionBtn) -> Void {
        switch type {
        case .modify:
            print("수정")
        case .remove:
            print("삭제")
        }
    }
}

// MARK: - BottomButtonFunction

extension TodoOptionSheetView {
    func bottomButton(_ type: TodoActionBtn, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 10, content: {
                type.caseIcon()
                    .fixedSize()
                
                Text(type.rawValue)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            })
        })
    }
    
    func bottomButtonAction(_ type: TodoActionBtn) -> Void {
        switch type {
        case .againTomorrow:
            print("내일 또 하기")
        case .anotherDay:
            print("다른 날 또 하기")
        case .replaceTheDate:
            print("날짜 바꾸기")
        }
    }
}

#Preview {
    TodoOptionSheetView()
}
