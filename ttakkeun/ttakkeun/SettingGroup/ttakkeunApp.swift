//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

@main
struct ttakkeunApp: App {
    var body: some Scene {
        WindowGroup {
            ToDoCheckList(viewModel: HomeSceduleViewModel(), data: TodoList(todoID: 1, todoName: "이빨닦기 및 청소", todoStatus: false))
        }
    }
}
