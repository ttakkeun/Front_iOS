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
    private var profileType: ProfileType
    
    init(
        scheduleViewModel: ScheduleViewModel,
        productViewModel: ProductViewModel,
        profileType: ProfileType
    ) {
        _offset = State(initialValue: 0)
        _lastoffset = State(initialValue: 0)
        self.scheduleViewModel = scheduleViewModel
        self.productViewModel = productViewModel
        self.profileType = profileType
        
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
    
    
    private var compatchComponents: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 21, content: {
                compactTodoGroup
                compactAIProduct
                compactTopProduct
            })
            .frame(width: 400)
            .padding(.horizontal, 10)
        }
    }
    
    // MARK: - 오늘의 일정 관리
    /// 드래그뷰 하단 오늘의 일정 관리 컴포넌트
    @ViewBuilder
    private var compactTodoGroup: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            titleText(text: "오늘의 일정 관리")
            
            if scheduleViewModel.earTodos.isEmpty && scheduleViewModel.eyeTodos.isEmpty && scheduleViewModel.hairTodos.isEmpty && scheduleViewModel.clawTodos.isEmpty && scheduleViewModel.toothTodos.isEmpty {
                HStack {
                    Spacer()
                    
                    HomeNotTodo()
                    
                    Spacer()
                }
                
            } else {
                
                ScrollView(.horizontal, showsIndicators: false, content: {
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
                    .padding(.horizontal, 5)
                })
            }
        })
        .onAppear {
            Task {
                await scheduleViewModel.getScheduleData(currentDate: scheduleViewModel.inputDate)
            }
            
        }
    }
    
    // MARK: - AI 추천 목록
    
    /// 따끈따끈 AI 추천 제품
    @ViewBuilder
    private var compactAIProduct: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleText(text: "\(petState.petName)를 위한 따끈 따끈 AI 추천 제품")
            
            if let resultData = productViewModel.aiProductData?.result {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 241)), count: 1), spacing: 12, content: {
                        ForEach(resultData.prefix(4), id: \.self ) { data in
                            HomeAIRecommendProduct(data: data)
                        }
                    })
                    .frame(height: 92)
                    .padding(.horizontal, 5)
                })
                .onAppear {
                    Task {
                        await productViewModel.getAIProduct()
                    }
                }
            } else {
                HStack {
                    Spacer()
                    
                    HomeNotRecommend(firstLine: "AI 추천 제품이 아직 없어요!", secondLine: "일지를 작성하고 AI 진단을 받으러 가볼까요?")
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                await productViewModel.getAIProduct()
            }
        }
    }
    
    /// 따끈나끈 유저 추천 제품
    private var compactTopProduct: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            titleText(text:  "\(type) \(petState.petName)를 위한 추천 제품 TOP8")
            
            if let resultData = productViewModel.userProductData?.result {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 90), spacing: 12), count: 4), spacing: 11, content: {
                        ForEach(Array(resultData.prefix(8).enumerated()), id: \.element) { index, data in
                            HomeUserRecommendProduct(data: data, rank: index)
                        }
                    })
                    .frame(height: 331)
                    .padding(.bottom, 80)
                    .padding(.leading, 12)
                })
            } else {
                HStack {
                    Spacer()
                    
                    HomeNotRecommend(firstLine: "유저 추천 제품이 아직 없어요!", secondLine: "다른 유저들의 추천 제품을 기다려 주세요!")
                    
                    Spacer()
                    
                }
            }
        })
        .onAppear {
            Task {
                await productViewModel.getUserProduct(page: 0)
            }
        }
    }
    
    // MARK: - Function
    private func titleText(text: String) -> some View {
        Text(text)
            .font(.H4_bold)
            .foregroundStyle(Color.gray_900)
    }
    
    private var type: String {
        switch self.profileType {
        case .cat:
            return "반려묘"
        case .dog:
            return "반려견"
        }
    }
    
}

struct HomeDragView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeDragView(scheduleViewModel: ScheduleViewModel(), productViewModel: ProductViewModel(), profileType: .cat)
                .environmentObject(PetState(petName: "유아", petId: 1))
        }
    }
}

