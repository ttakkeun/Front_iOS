//
//  ToDoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import SwiftUI

/// 투두 항목의 체크 리스트
struct ToDoCheckList<ViewModel: TodoCheckProtocol & ObservableObject>: View {
    
    @Binding var data: TodoList
    @ObservedObject var viewModel: ViewModel
    let parItem: PartItem
    let checkAble: Bool
    
    @State private var isSheetPresented = false
    
    
    // MARK: - Init
    
    init(
        data: Binding<TodoList>,
        viewModel: ViewModel,
        partItem: PartItem,
        checkAble: Bool = false
    ) {
        self._data = data
        self.viewModel = viewModel
        self.parItem = partItem
        self.checkAble = checkAble
    }
    
    var body: some View {
        checkComponents.sheet(isPresented: $isSheetPresented) {
            TodoControlSheet(todoName: data.todoName, isChecked: data.todoStatus)
                .presentationDetents([.fraction(0.38)])
                .presentationCornerRadius(30)
                .padding(.top, 10)
            }
    }
    
    // MARK: - Contents
    
    private var checkComponents: some View {
        HStack(alignment: .center, spacing: 6, content: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    data.todoStatus.toggle()
                    Task {
                        viewModel.toggleTodoStatus(for: parItem, todoID: data.id)
                    }
                }
            }, label: {
                if !data.todoStatus {
                    Icon.unCheckBox.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .opacity(data.todoStatus ? 0 : 1)
                    
                } else {
                    ZStack {
                        Icon.checkBox.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Icon.checkV.image
                            .fixedSize()
                    }
                }
            })
            if checkAble {
                Button(action: {
                    ///텍스트 누르면 시트뷰 띄움
                    isSheetPresented = true
                }, label: {
                    Text(data.todoName)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray_900)
                })
            } else {
                Text(data.todoName)
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray_900)
            }
            
        })
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
    }
}
