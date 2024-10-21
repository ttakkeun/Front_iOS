//
//  WriteCategory.swift
//  ttakkeun
//
//  Created by 한지강 on 8/8/24.
//

import SwiftUI

/// floating버튼 누르면 위로 나오는 카테고리 별 작성버튼
struct WriteCategory: View {
    var tipscategory: TipsCategorySegment
    
    //MARK: - Init
    init(tipscategory: TipsCategorySegment) {
        self.tipscategory = tipscategory
    }
    
    //MARK: - Contents
    var body: some View {
        HStack(spacing: 6) {
            if tipscategory != .etc {
                categorySet
                categoryText
            } else {
                categoryText
            }
        }
        .padding(.vertical, 10)
        .frame(width: 112, height: 47)
        .background(
            RoundedRectangle(cornerRadius: 999)
                .fill(Color.white))
        .clipShape(RoundedRectangle(cornerRadius: 999))
    }
    
    /// 카테고리 텍스트
    private var categoryText: some View {
        Text(tipscategory.toKorean())
            .font(.Body2_medium)
            .foregroundStyle(Color.gray900)
    }
    
    /// 카테고리 이미지와 뒷 배경 그래디언트
    private var categorySet: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: categoryGradientColors(tipscategory: tipscategory)),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 30, height: 30)
                .blur(radius: 4)
            
            categoryImage(tipscategory: tipscategory)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    //MARK: - function
    
    /// category 뒷배경 GradientColor
    /// - Parameter tipscategory: Category
    /// - Returns: 카테고리에 맞는 색
    private func categoryGradientColors(tipscategory: TipsCategorySegment) -> [Color] {
        switch tipscategory {
        case .ear:
            return [Color.qnAEar, Color.qnAEar]
        case .eye:
            return [Color.beforeEye, Color.beforeEye]
        case .hair:
            return [Color.beforeHair, Color.beforeHair]
        case .claw:
            return [Color.beforeClaw, Color.beforeClaw]
        case .tooth:
            return [Color.beforeTeeth, Color.beforeTeeth]
        case .etc, .all, .best:
            return [Color.clear, Color.clear]
        }
    }
    
    /// category 이미지
    /// - Parameter tipscategory: category
    /// - Returns: category에 맞는 이미지
    private func categoryImage(tipscategory: TipsCategorySegment) -> Image {
        switch tipscategory {
        case .ear:
            return Icon.homeEar.image
        case .eye:
            return Icon.homeEye.image
        case .hair:
            return Icon.homeHair.image
        case .claw:
            return Icon.homeClaw.image
        case .tooth:
            return Icon.homeTeeth.image
        case .etc, .all, .best:
            return Image(systemName: " ")
        }
    }
}

//MARK: - Preview
struct WriteCategory_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            WriteCategory(tipscategory: .ear)
            WriteCategory(tipscategory: .eye)
            WriteCategory(tipscategory: .hair)
            WriteCategory(tipscategory: .claw)
            WriteCategory(tipscategory: .tooth)
            WriteCategory(tipscategory: .etc)
        }
        .background(Color.gray200)
    }
}
