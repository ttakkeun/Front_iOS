import SwiftUI

/// 카테고리 선택하고 그에 대한 Tip작성할 수 있도록 하는 플로팅 버튼
struct FloatingWriteBtn: View {
    @State var isPresented: Bool = false
    
    //MARK: - Contents
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if isPresented {
                backgroundOpacity
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
            }
            VStack(alignment: .trailing, spacing: 11) {
                Spacer()
                if isPresented {
                    clickedfloatingBtn
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(1)
                }
                HStack {
                    Spacer()
                    floatingBtn
                }
            }
            .padding(.trailing, 24)
            .animation(.easeInOut, value: isPresented)
        }
    }
    
    /// 플로팅 버튼 > 클릭하면 x, 클릭안하면 연필
    private var floatingBtn: some View {
        Button(action: {
            withAnimation {
                isPresented.toggle()
            }
        }) {
            ZStack {
                if isPresented {
                    Circle()
                        .frame(width: 67, height: 67)
                        .foregroundStyle(Color.postBg)
                        .clipShape(Circle())
                    
                    Icon.cancel.image
                        .fixedSize()
                        .foregroundColor(.gray900)
                    
                } else {
                    Circle()
                        .frame(width: 67, height: 67)
                        .foregroundStyle(Color.mainBg)
                        .clipShape(Circle())
                    
                    Icon.write.image
                        .fixedSize()
                }
            }
        }
    }
    
    /// 플로팅 버튼 클릭되었을 때 위로 나오는 카테고리들
    private var clickedfloatingBtn: some View {
        VStack(spacing: 13) {
            ForEach(TipsCategorySegment.allCases.filter { $0 != .all && $0 != .best }, id: \.self) { category in
                NavigationLink(destination: QnaWriteTipsView(category: category)) {
                    WriteCategory(tipscategory: category)
                }
            }
        }
    }
    
    /// 플로팅버튼 클릭되었을때 뒷 배경 opacity
    private var backgroundOpacity: some View {
        Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6)
            .ignoresSafeArea(.all)
    }
}

//MARK: - Preview
#Preview{
    FloatingWriteBtn()
}
