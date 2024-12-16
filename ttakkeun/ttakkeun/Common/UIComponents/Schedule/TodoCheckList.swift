//
//  TodoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

/// 투두 박스 내부에서 쓰이는 체크 리스트 항목
struct TodoCheckList<ViewModel: TodoCheckProtocol & ObservableObject>: View {
    
    @Binding var data: TodoList
    @ObservedObject var viewModel: ViewModel
    let partItem: PartItem
    let checkAble: Bool
    
    @State var isShowSheet: Bool = false
    
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
    
    var body: some View {
        checkComponents
            .sheet(isPresented: $isShowSheet, content: {
                TodoOptionSheetView(viewModel: viewModel as! TodoCheckViewModel, selectedTodo: $data)
                    .presentationCornerRadius(30)
                    .presentationDetents([.fraction(0.45)])
            })
    }
    
    private var checkComponents: some View {
        HStack(alignment: .center, spacing: 6, content: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.toggleTodoStatus(for: partItem, todoID: data.id)
                    viewModel.sendTodoStatus(todoId: data.todoID)
                }
            }, label: {
                if !data.todoStatus {
                    Icon.unCheckBox.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .opacity(data.todoStatus ? 0 : 1)
                } else {
                    ZStack {
                        Icon.checkBox.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                        
                        Icon.checkV.image
                            .fixedSize()
                    }
                }
            })
            
            Button(action: {
                if checkAble {
                    isShowSheet = true
                }
            }, label: {
                Text(data.todoName)
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
            })
            
        })
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
    }
}

struct TodoCheckList_Preview: PreviewProvider {
    static var previews: some View {
        TodoCard(partItem: .ear, container: DIContainer())
    }
}
