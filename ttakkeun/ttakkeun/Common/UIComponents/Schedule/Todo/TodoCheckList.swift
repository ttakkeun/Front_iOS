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
    
    private var contentsHspacing: CGFloat = 6
    private var contentdHeight: CGFloat = 16
    private var presentFraction: CGFloat = 0.4
    private var buttonAnimation: CGFloat = 0.2
    private var imageSize: CGSize = .init(width: 18, height: 18)
    
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
        HStack(alignment: .center, spacing: contentsHspacing, content: {
            leftButton
            rightButton
        })
        .frame(maxWidth: .infinity, maxHeight: contentdHeight, alignment: .leading)
        .sheet(isPresented: $isShowSheet, content: {
            TodoOptionSheetView(viewModel: viewModel as! TodoCheckViewModel, selectedTodo: $data, isShowSheet: $isShowSheet)
                .presentationCornerRadius(UIConstants.sheetCornerRadius)
                .presentationDetents([.fraction(presentFraction)])
        })
    }
    
    private var leftButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: buttonAnimation)) {
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
            .frame(width: imageSize.width, height: imageSize.height)
            .opacity(data.todoStatus ? .zero : 1)
    }
    
    private var checkStatus: some View {
        ZStack {
            Image(.checkBox)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize.width, height: imageSize.height)
            
            Image(.checkV)
                .fixedSize()
        }
    }
}
