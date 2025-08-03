//
//  FloatingCategory.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

/// 플로팅 카테고리 설정
struct FloatingCategory: View {
    
    // MARK: - Property
    let floatingCategory: ExtendPartItem
    
    // MARK: - Constants
    fileprivate enum FloatingCategoryConstants {
        static let contentsHspacing: CGFloat = 8
        static let contentsPadding: EdgeInsets = .init(top: 10, leading: 24, bottom: 10, trailing: 26)
        
        static let circleSize: CGSize = .init(width: 32, height: 32)
        static let contentsSize: CGSize = .init(width: 70, height: 30)
        static let cornerRadius: CGFloat = 999
        static let blurValue: CGFloat = 4
    }
    
    // MARK: - Init
    init(floatingCategory: ExtendPartItem) {
        self.floatingCategory = floatingCategory
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: FloatingCategoryConstants.contentsHspacing, content: {
            etcFloatingBranch
            categoryText
        })
        .frame(width: FloatingCategoryConstants.contentsSize.width, height: FloatingCategoryConstants.contentsSize.height)
        .padding(FloatingCategoryConstants.contentsPadding)
        .background {
            RoundedRectangle(cornerRadius: FloatingCategoryConstants.cornerRadius)
                .fill(Color.white)
        }
    }
    
    /// 플로팅 버튼 기타 카테고리 제외 분기
    @ViewBuilder
    private var etcFloatingBranch: some View {
        if floatingCategory != .etc {
            categoryIcon
        }
    }
    
    /// 카테고리 텍스트
    private var categoryText: Text {
        Text(floatingCategory.toKorean())
            .font(.Body2_medium)
            .foregroundStyle(Color.gray900)
    }
    
    /// 카테고리 아이콘 값
    private var categoryIcon: some View {
        ZStack(alignment: .center, content: {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: makeCategoryColor()),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: FloatingCategoryConstants.circleSize.width, height: FloatingCategoryConstants.circleSize.height)
                .blur(radius: FloatingCategoryConstants.blurValue)
            
            makeCategoryImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
}

extension FloatingCategory {
    
    func makeCategoryColor() -> [Color] {
        switch floatingCategory {
        case .all, .best, .etc:
            return [Color.clear, Color.clear]
        case .part(let partItem):
            return [partItem.toColor(), partItem.toColor()]
        }
    }
    
    func makeCategoryImage() -> Image {
        switch floatingCategory {
        case .all, .best , .etc:
            return Image(systemName: "")
        case .part(let partItem):
            return partItem.toImage()
        }
    }
}

#Preview {
    FloatingCategory(floatingCategory: .part(.teeth))
}
