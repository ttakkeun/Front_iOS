//
//  TodoCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

/// 스케줄 탭 내부의 투두 항목
struct TodoCard: View {
    
    // MARK: - Property
    @State var viewModel: TodoCheckViewModel
    @Bindable var calendarViewModel: CalendarViewModel
    @AppStorage(AppStorageKey.petId) var petId: Int = 0
    @FocusState var isFoucused: Bool
    
    // MARK: - Constants
    fileprivate enum TodoCardConstants {
        static let todoListHspacing: CGFloat = 22
        static let todoListVspacing: CGFloat = 5
        static let todoOptionHspacing: CGFloat = 8
        
        static let plusImageSize: CGSize = .init(width: 20, height: 20)
        static let todoOptionImageSize: CGSize = .init(width: 18, height: 18)
        static let contentsPadding: EdgeInsets = EdgeInsets(top: 13, leading: 14, bottom: 13, trailing: 14)
        
        static let buttonAnimationTime: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 10
        
        static let notExistTodoListText: String = "Todo List를 만들어볼까요?"
        static let newTodoPlaceholder: String = "내용을 입력해주세요!!"
    }
    
    // MARK: - Init
    init(partItem: PartItem, container: DIContainer, calendarViewModel: CalendarViewModel) {
        self.viewModel = .init(partItem: partItem, container: container)
        self.calendarViewModel = calendarViewModel
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: TodoCardConstants.todoListHspacing, content: {
            leftTodoCircleBtn
            middleTodoContents
        })
        .padding(TodoCardConstants.contentsPadding)
        .overlay(content: {
            mainBackground
        })
        .onChange(of: calendarViewModel.selectedDate, { old, new in
            viewModel.getTodoData(date: new)
        })
        .keyboardToolbar {
            isFoucused = false
        }
    }
    
    private var mainBackground: some View {
        RoundedRectangle(cornerRadius: TodoCardConstants.cornerRadius)
            .fill(Color.clear)
            .stroke(Color.gray200, style: .init())
    }
    
    // MARK: - Left
    /// 왼쪽 투두 버튼
    private var leftTodoCircleBtn: some View {
        ZStack(alignment: .topTrailing, content: {
            TodoCircle(partItem: viewModel.partItem, isBefore: true)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.isAddingNewTodoToggle()
                }
            }, label: {
                leftTodoCircle
            })
            .disabled(viewModel.isAddingNewTodo == true ? true : false)
        })
    }
    
    /// 왼쪽 투두 버튼 내부 컨텐츠
    private var leftTodoCircle: some View {
        Image(.todoPlus)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: TodoCardConstants.plusImageSize.width, height: TodoCardConstants.plusImageSize.height)
    }
    
    // MARK: - MiddleContents
    /// 중간 체크 리스트 컨텐츠
    @ViewBuilder
    private var middleTodoContents: some View {
        if viewModel.todos.isEmpty {
            notTodoChecList
        } else {
            todoCheckList
        }
    }
    
    // MARK: - Middle_NotTodo
    @ViewBuilder
    private var notTodoChecList: some View {
        if viewModel.isAddingNewTodo {
            newTodoInputField
        } else {
            notTodoText
        }
    }
    
    /// 투두 존재하지 않을 시 보일 텍스트
    private var notTodoText: some View {
        Text(TodoCardConstants.notExistTodoListText)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray400)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Middle_NewTodo
    /// 투두 가운데 체크 리스트
    private var todoCheckList: some View {
        VStack(alignment: .leading, spacing: TodoCardConstants.todoListVspacing, content: {
            todoForEach
            newTodoInputField
        })
    }
    
    /// 투두 리스트 반복 생성
    private var todoForEach: some View {
        ForEach($viewModel.todos, id: \.id) { todo in
            TodoCheckList(data: todo, viewModel: viewModel, partItem: viewModel.partItem, checkAble: true)
        }
    }
    
    /// 투두 텍스트 필드 생성 시
    @ViewBuilder
    private var newTodoInputField: some View {
        if viewModel.isAddingNewTodo {
            HStack {
                Image(.unCheckBox)
                    .fixedSize()
                todoTextField
                Spacer()
                todoOptionButton
            }
        }
    }
    
    /// 투두 입력 텍스트 필드
    private var todoTextField: some View {
        VStack(spacing: .zero, content: {
            TextField("" ,text: $viewModel.newTodoText, prompt: placeholder())
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .submitLabel(.done)
                .onSubmit {
                    addNewTodo()
                }
                .focused($isFoucused)
            
            Divider()
                .background(Color.mainPrimary)
        })
    }
    
    /// 투두 생성 취소 옵션 버튼
    private var todoOptionButton: some View {
        HStack(spacing: TodoCardConstants.todoOptionHspacing, content: {
            makeButton(action: addNewTodo, image: .plus)
            makeButton(action: minusTodo, image: .minus)
        })
    }
    
    /// 마이너스 버튼 액션
    func minusTodo() {
        viewModel.isAddingNewTodo = false
        viewModel.newTodoText = ""
    }
    
    /// 추가 버튼 액션
    func addNewTodo() {
        guard !viewModel.newTodoText.isEmpty else { return }
        
        viewModel.makeTodoContetns(makeTodoData: .init(
            petId: petId,
            todoCategory: viewModel.partItem.rawValue,
            todoName: viewModel.newTodoText)
        )
    }
    
    /// 투두 옵션 생성 버튼
    /// - Parameters:
    ///   - action: 버튼 액션
    ///   - image: 버튼 이미지
    /// - Returns: 버튼 반환
    func makeButton(action: @escaping () -> Void, image: ImageResource) -> some View {
        Button(action: {
            withAnimation(.smooth(duration: TodoCardConstants.buttonAnimationTime)) {
                action()
            }
        }, label: {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: TodoCardConstants.todoOptionImageSize.width, height: TodoCardConstants.todoOptionImageSize.height)
        })
    }
    
    private func placeholder() -> Text {
        Text(TodoCardConstants.newTodoPlaceholder)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray500)
    }
}

#Preview {
    TodoCard(partItem: .ear, container: DIContainer(), calendarViewModel: .init(month: .now, calendar: .current, container: DIContainer()))
}
