//
//  TodoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

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
                Text("hello")
            })
    }
    
    private var checkComponents: some View {
        HStack(alignment: .center, spacing: 6, content: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    data.todoStatus.toggle()
                    viewModel.toggleTodoStatus(for: partItem, todoID: data.id)
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
            Text(data.todoName)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .onTapGesture {
                    if checkAble {
                        isShowSheet = true
                    }
                }
        })
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
    }
}
