//
//  TodoOptionSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

/// 투두 관련 설정 옵션 시트 뷰
struct TodoOptionSheetView: View {
    
    // MARK: - Property
    @Bindable var viewModel: TodoCheckViewModel
    @Binding var selectedTodo: TodoList
    @Binding var isShowSheet: Bool
    
    @State private var showCalendar = false
    @State private var selectedDate = Date()
    @State private var actionType: TodoActionBtn? = nil
    @State private var modifyTitle: Bool = false
    @FocusState private var isTitleFocused: Bool
    
    // MARK: - Constants
    fileprivate enum TodoOptionSheetConstants {
        static let contentsVspacing: CGFloat = 23
        static let middleHpsacing: CGFloat = 9
        static let bottomVspacing: CGFloat = 14
        static let bottomBtnHspacing: CGFloat = 10
        
        static let popOverHeight: CGFloat = 450
        static let btnHeight: CGFloat = 46
        static let cornerRadius: CGFloat = 10
        static let presentCornerRadius: CGFloat = 30
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: TodoOptionSheetConstants.contentsVspacing, content: {
            topContents
            middleContents
            bottomContents
        })
        .safeAreaInset(edge: .top, content: {
            Capsule()
                .modifier(CapsuleModifier())
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .popover(isPresented: $showCalendar, content: {
            CalendarPickerView(selectedDate: $selectedDate) { date in
                dateSelection(date)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(TodoOptionSheetConstants.popOverHeight)])
            .presentationCornerRadius(TodoOptionSheetConstants.presentCornerRadius)
        })
    }
    // MARK: - PopOver
    /// 날짜 선택 후 서버 전송 함수
    /// - Parameter date: 선택한 날짜
    private func dateSelection(_ date: Date) {
        guard let type = actionType else { return }
        let formattedDate = date.formattedForAPI()
        
        switch type {
        case .anotherDay:
            viewModel.postAnotherDay(todoId: selectedTodo.todoID, newDate: formattedDate)
        case .replaceTheDate:
            viewModel.patchTodoTransferAnotherDay(todoId: selectedTodo.todoID, newDate: formattedDate)
        default:
            break
        }
        
        isShowSheet = false
    }
    
    // MARK: - TopContents
    /// 상단 투두 이름 텍스트
    private var topContents: some View {
        HStack(content: {
            Spacer()
            TextField("", text: $selectedTodo.todoName)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray900)
                .disabled(!modifyTitle)
                .focused($isTitleFocused)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .onSubmit {
                    // MARK: - 변경 이름 서버 전송
                }
            Spacer()
        })
    }
    
    // MARK: - MiddleContents
    private var middleContents: some View {
        HStack(spacing: TodoOptionSheetConstants.middleHpsacing, content: {
            ForEach(TodoOptionBtn.allCases, id: \.self) { type in
                optionButton(type: type, action: {
                    buttonAction(type)
                })
            }
        })
    }
    
    func buttonAction(_ type: TodoOptionBtn) -> Void {
        switch type {
        case .modify:
            modifyTitle = true
            isTitleFocused = true
        case .remove:
            viewModel.deleteTodo(todoId: selectedTodo.todoID)
            isShowSheet = false
        }
    }
    
    /// 중간 수정 및 삭제 버튼 구성
    /// - Parameters:
    ///   - type: 수정 및 삭제 타입
    ///   - action: 버튼 액션 지정
    /// - Returns: 버튼 뷰 반환
    func optionButton(type: TodoOptionBtn, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            optionButtonContents(type: type)
        })
    }
    
    /// 옵션 버튼 컨텐츠
    /// - Parameter type: 버튼 타입
    /// - Returns: 버튼 컨텐츠 반환
    private func optionButtonContents(type: TodoOptionBtn) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: TodoOptionSheetConstants.cornerRadius)
                .fill(type.bgColor)
                .frame(maxWidth: .infinity)
                .frame(height: TodoOptionSheetConstants.btnHeight)
            
            Text(type.rawValue)
                .font(.Body3_medium)
                .foregroundStyle(type.fontColor)
        }
    }
    
    // MARK: - BottomContents
    /// 하단 날짜 관련 옵션 버튼 지정
    private var bottomContents: some View {
        VStack(alignment: .leading, spacing: TodoOptionSheetConstants.bottomVspacing, content: {
            bottomContentsBranch
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Todo 버튼 초기에 따른 버튼 분기점
    @ViewBuilder
    private var bottomContentsBranch: some View {
        let tasks = selectedTodo.todoStatus ? TodoActionBtn.checkedTask() : TodoActionBtn.uncheckTask()
        
        ForEach(tasks, id: \.self) { type in
            bottomButton(type, action: {
                bottomButtonAction(type)
            })
        }
    }
    
    /// 아래 버튼
    /// - Parameters:
    ///   - type: 버튼 타입
    ///   - action: 버튼 액션
    /// - Returns: 버튼 반환
    private func bottomButton(_ type: TodoActionBtn, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            bottomBtnContents(type: type)
        })
    }
    
    /// 하단 버튼 컨텐츠
    /// - Parameter type: 버튼 타입
    /// - Returns: 버튼 컨텐츠 반환
    private func bottomBtnContents(type: TodoActionBtn) -> some View {
        HStack(spacing: TodoOptionSheetConstants.bottomBtnHspacing, content: {
            type.caseIcon()
                .fixedSize()
            
            Text(type.rawValue)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
        })
    }
    
    /// 각 버튼의 액션 지정
    /// - Parameter type: 각 버튼의 액션
    /// - Returns: 액션 반환
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

/// 날짜 이동 시 등장하는 캘린더 피커 선택 뷰
fileprivate struct CalendarPickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var onConfirm: (Date) -> Void
    
    var body: some View {
        DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .onChange(of: selectedDate) { old, new in
                onConfirm(new)
                dismiss()
            }
            .tint(Color.primarycolor600)
    }
}

struct TodoOptionSheetView_Preview: PreviewProvider {
    static var previews: some View {
        TodoOptionSheetView(viewModel: TodoCheckViewModel(partItem: .claw, container: DIContainer()), selectedTodo: .constant(.init(todoID: 1, todoName: "테스트입니다아아", todoStatus: true)), isShowSheet: .constant(true))
            .presentationCornerRadius(30)
            .presentationDetents([.fraction(0.45)])
    }
}
