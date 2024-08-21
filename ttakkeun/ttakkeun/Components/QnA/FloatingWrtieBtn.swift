import SwiftUI

/// 카테고리 선택하고 그에 대한 Tip작성할 수 있도록 하는 플로팅 버튼
struct FloatingWriteBtn: View {
    @Binding  var isPresented: Bool
    @State private var selectedCategory: TipsCategorySegment? = nil
    
    //MARK: - Contents
    var body: some View {
        GeometryReader { geo in
            ZStack {
                    floatingBtn
                        .position(x: geo.size.width * 0.85, y: geo.size.height * 0.85)
                    if isPresented {
                        clickedfloatingBtn(geo: geo)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
            }
            .background(isPresented ? Color.btnBackground.opacity(0.6) : Color.clear)
            .onTapGesture {
                withAnimation {
                    isPresented = false
                }
            }
            .fullScreenCover(item: $selectedCategory) { category in
                QnaWriteTipsView(viewModel: QnaWriteTipsViewModel(category: category), category: category)
            }
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
    private func clickedfloatingBtn(geo: GeometryProxy) -> some View {
        VStack(spacing: 13) {
            ForEach(TipsCategorySegment.allCases.filter { $0 != .all && $0 != .best }, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                    isPresented = false
                }) {
                    WriteCategory(tipscategory: category)
                }
            }
        }
        .position(x: geo.size.width * 0.8, y: geo.size.height * 0.55)
    }
}

//MARK: - Preview
struct FloatingWriteBtn_Previews: PreviewProvider {
    static var previews: some View {
        FloatingWriteBtn(isPresented: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
