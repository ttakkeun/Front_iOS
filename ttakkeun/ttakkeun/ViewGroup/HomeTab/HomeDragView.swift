//
//  HomeDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// 홈화면 드래그 뷰
struct HomeDragView: View {
    
    @State private var offset: CGFloat
    @State private var lastoffset: CGFloat
    @GestureState private var dragOffset: CGFloat = 0
    
    @ObservedObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var productViewModel: ProductViewModel
    @EnvironmentObject var petState: PetState
    
    init(
        scheduleViewModel: ScheduleViewModel,
        productViewModel: ProductViewModel
    ) {
        _offset = State(initialValue: 0)
        _lastoffset = State(initialValue: 0)
        self.scheduleViewModel = scheduleViewModel
        self.productViewModel = productViewModel
    }
    
    // MARK: - Contents
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let minOffset: CGFloat = screenHeight * 0.45
            let maxOffset: CGFloat = screenHeight * 0.06
            
            /* 임계값을 두어 드래그뷰를 위 아래로 조절한다. */
            VStack(alignment: .center, spacing: 21) {
                Capsule()
                    .fill(Color.gray_300)
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                
                compatchComponents
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(.rect(topLeadingRadius: 30, topTrailingRadius: 30))
            .shadow03()
            .offset(y: offset + dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset, body: { value, state, _ in
                        let newOffset = offset + value.translation.height
                        if newOffset > minOffset {
                            state = minOffset - offset
                        } else if newOffset < maxOffset {
                            state = maxOffset - offset
                        } else {
                            state = value.translation.height
                        }
                    })
                    .onEnded({ value in
                        let threshold: CGFloat = 50
                        if value.translation.height < -threshold {
                            offset = maxOffset
                        } else {
                            offset = minOffset
                        }
                        lastoffset = offset
                    })
            )
            .onAppear {
                self.offset = minOffset
            }
        }
        .animation(.interactiveSpring(), value: offset)
    }
    
    // MARK: - Components
    private var compatchComponents: some View {
        VStack(alignment: .leading, spacing: 21, content: {
            compactTodoGroup
        })
        .frame(width: 350)
        .padding(.horizontal, 20)
    }
    
    /// 드래그뷰 하단 오늘의 일정 관리 컴포넌트
    private var compactTodoGroup: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            titleText(text: "오늘의 일정 관리")
            
            ScrollView(.horizontal, content: {
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 147)), count: 1), spacing: 12, content: {
                    /* earTodos ForEach*/
                    if !scheduleViewModel.earTodos.isEmpty {
                        CompactTodo(viewModel: scheduleViewModel, partItem: .ear)
                    }
                    /* hairTodos ForEach*/
                    if !scheduleViewModel.hairTodos.isEmpty {
                        CompactTodo(viewModel: scheduleViewModel, partItem: .hair)
                    }
                    /* clawTodos ForEach*/
                    if !scheduleViewModel.clawTodos.isEmpty {
                        CompactTodo(viewModel: scheduleViewModel, partItem: .claw)
                    }
                    /* eyeTodos ForEach*/
                    if !scheduleViewModel.eyeTodos.isEmpty {
                        CompactTodo(viewModel: scheduleViewModel, partItem: .eye)
                    }
                    /* toothTodos ForEach*/
                    if !scheduleViewModel.toothTodos.isEmpty {
                        CompactTodo(viewModel: scheduleViewModel, partItem: .tooth)
                    }
                    
                })
                .frame(height: 180)
                .padding(.leading, 5)
                .scrollIndicators(.hidden)
            })
        })
        .onAppear {
            Task {
                await scheduleViewModel.getScheduleData(currentDate: scheduleViewModel.inputDate)
            }
            
        }
    }
    
    // MARK: - Function
    private func titleText(text: String) -> some View {
        Text(text)
            .font(.H4_bold)
            .foregroundStyle(Color.gray_900)
    }
    
}

struct HomeDragView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeDragView(scheduleViewModel: ScheduleViewModel(), productViewModel: ProductViewModel())
                .environmentObject(PetState())
        }
    }
}

