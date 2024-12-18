//
//  TodoOptionSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct TodoOptionSheetView: View {
    
    @ObservedObject var viewModel: TodoCheckViewModel
    @Binding var selectedTodo: TodoList
    @Binding var isShowSheet: Bool
    
    @State private var showCalendar = false
    @State private var selectedDate = Date()
    @State private var actionType: TodoActionBtn? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 30, content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            mainContents
        })
        .popover(isPresented: $showCalendar, content: {
            CalendarPickerView(selectedDate: $selectedDate) { date in
                guard let type = actionType else { return }
                let formattedDate = DataFormatter.shared.formatDateForAPI(date)
                
                switch type {
                case .anotherDay:
                    viewModel.postAnotherDay(todoId: selectedTodo.todoID, newDate: formattedDate)
                    isShowSheet = false
                case .replaceTheDate:
                    viewModel.patchTodoTransferAnotherDay(todoId: selectedTodo.todoID, newDate: formattedDate)
                    isShowSheet = false
                default:
                    break
                }
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.5)])
            .presentationCornerRadius(30)
        })
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
            
            Text(selectedTodo.todoName)
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
            
            if selectedTodo.todoStatus {
                ForEach(TodoActionBtn.checkedTask(), id: \.self) { type in
                    bottomButton(type, action: {
                        bottomButtonAction(type)
                    })
                }
            } else {
                ForEach(TodoActionBtn.uncheckTask(), id: \.self) { type in
                    bottomButton(type, action: {
                        bottomButtonAction(type)
                    })
                }
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
            return Color.completionFront
        case .remove:
            return Color.postBg
        }
    }
    
    func buttonAction(_ type: TodoOptionBtn) -> Void {
        switch type {
        case .modify:
            print("수정")
        case .remove:
            viewModel.deleteTodo(todoId: selectedTodo.todoID)
            isShowSheet = false
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
            viewModel.postRepeatTodo(todoId: selectedTodo.todoID)
            isShowSheet = false
            print("내일 또하기 클릭")
        case .tomorrowDay:
            viewModel.patchTodoTransferTomorrow(todoId: selectedTodo.todoID)
            isShowSheet = false
            print("내일하기 클릭")
        case .anotherDay:
            actionType = type
            showCalendar = true
            print("다른 날짜 또 하기 클릭")
        case .replaceTheDate:
            actionType = type
            showCalendar = true
            print("날짜 바꾸기 클릭")
        }
    }
}

fileprivate struct CalendarPickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var onConfirm: (Date) -> Void
    
    var body: some View {
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .onChange(of: selectedDate) { newDate, oldValue in
                    onConfirm(newDate)
                    dismiss()
                }
    }
}

struct TOdoOptionSheetView_Preview: PreviewProvider {
    static var previews: some View {
        TodoOptionSheetView(viewModel: TodoCheckViewModel(partItem: .claw, container: DIContainer()), selectedTodo: .constant(.init(todoID: 1, todoName: "테스트입니다아아", todoStatus: true)), isShowSheet: .constant(true))
    }
}
