//
//  TodoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

/// 투두 박스 내부에서 쓰이는 체크 리스트 항목
struct TodoCheckList<ViewModel: TodoCheckProtocol>: View {
    
    // MARK: - Property
    @Binding var data: TodoList
    @State var isShowSheet: Bool = false
    
    var viewModel: ViewModel
    let partItem: PartItem
    let checkAble: Bool
    
    
    // MARK: - Init
    init(
        data: Binding<TodoList>,
        viewModel: ViewModel,
        partItem: PartItem,
        checkAble: Bool = false
    ) {
        self._data = data
        self.viewModel = viewModel
        self.partItem = partItem
        self.checkAble = checkAble
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: 6, content: {
            leftButton
            rightButton
        })
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
        .sheet(isPresented: $isShowSheet, content: {
            TodoOptionSheetView(viewModel: viewModel as! TodoCheckViewModel, selectedTodo: $data, isShowSheet: $isShowSheet)
                .presentationCornerRadius(30)
                .presentationDetents([.fraction(0.4)])
        })
    }
    
    private var leftButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.toggleTodoStatus(for: partItem, todoID: data.id)
                viewModel.sendTodoStatus(todoId: data.todoID)
            }
        }, label: {
            checkBranch
        })
    }
    
    private var rightButton: some View {
        Button(action: {
            if checkAble {
                isShowSheet = true
            }
        }, label: {
            Text(data.todoName)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
        })
    }
    
    @ViewBuilder
    private var checkBranch: some View {
        if !data.todoStatus {
            unCheckStatus
        } else {
            checkStatus
        }
    }
    
    private var unCheckStatus: some View {
        Image(.unCheckBox)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
            .opacity(data.todoStatus ? 0 : 1)
    }
    
    private var checkStatus: some View {
        ZStack {
            Image(.checkBox)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
            
            Image(.checkV)
                .fixedSize()
        }
    }
}

struct TodoCheckList_Preview: PreviewProvider {
    static var previews: some View {
        TodoCard(partItem: .ear, container: DIContainer())
    }
}
