//
//  HomeDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeDragView: View {
    
    @State private var offset: CGFloat
    @State private var lastOffset: CGFloat
    @GestureState private var dragOffset: CGFloat = 0
    
    @ObservedObject var homeProfileCardViewModel: HomeProfileCardViewModel
    @ObservedObject var homeRecommendViewModel: HomeRecommendViewModel
    @ObservedObject var homeTodoViewModel: HomeTodoViewModel
    
    init(
        homeProfileCardViewModel: HomeProfileCardViewModel,
        homeRecommendViewModel: HomeRecommendViewModel,
        homeTodoViewModel: HomeTodoViewModel
    ) {
        _offset = State(initialValue: 0)
        _lastOffset = State(initialValue: 0)
        self.homeProfileCardViewModel = homeProfileCardViewModel
        self.homeRecommendViewModel = homeRecommendViewModel
        self.homeTodoViewModel = homeTodoViewModel
    }
    
    var body: some View {
        
        if homeRecommendViewModel.aiRecommendIsLoading ||
                   homeRecommendViewModel.userRecommendIsLoading ||
                   homeTodoViewModel.todoIsLoading {
            loadingView
        } else {
            bottomDrag
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("잠시만 기다려주세요...")
                .progressViewStyle(CircularProgressViewStyle())
                .controlSize(.large)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
    
    private var bottomDrag: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let minOffset: CGFloat = screenHeight * 0.45
            let maxOffset: CGFloat = screenHeight * 0.07
            
            VStack(alignment: .center, spacing: 13) {
                Image(systemName: offset == minOffset ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 38, height: 15)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                
                compactComponents(petType: homeProfileCardViewModel.profileData?.type)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.2)) {
                            if value.translation.height < -threshold {
                                offset = maxOffset
                            } else {
                                offset = minOffset
                            }
                        }
                        lastOffset = offset
                    }
            )
            .onAppear {
                offset = screenHeight
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 1.4, dampingFraction: 0.8)) {
                        offset = minOffset
                    }
                }
            }
        }
    }
    
    private func compactComponents(petType: ProfileType?) -> some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: 24, content: {
                HomeTodo(viewModel: homeTodoViewModel)
                HomeAIProduct(viewModel: homeRecommendViewModel)
                HomeTop(viewModel: homeRecommendViewModel, petType: homeProfileCardViewModel.profileData?.type)
            })
            .safeAreaPadding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 20))
            .padding(.bottom, 80)
        })
    }
}
