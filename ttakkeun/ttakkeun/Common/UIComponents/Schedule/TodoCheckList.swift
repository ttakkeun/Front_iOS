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
        Text("hello")
    }
}
