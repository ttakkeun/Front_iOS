//
//  FloatingCategory.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct FloatingCategory: View {
    
    let floatingCategory: ExtendPartItem
    
    init(floatingCategory: ExtendPartItem) {
        self.floatingCategory = floatingCategory
    }
    
    var body: some View {
        HStack(spacing: 8, content: {
            if floatingCategory != .etc {
                categoryIcon
                categoryText
            } else {
                categoryText
            }
        })
        .frame(width: 70, height: 30)
        .padding(.vertical, 10)
        .padding(.leading, 24)
        .padding(.trailing, 26)
        .background {
            RoundedRectangle(cornerRadius: 999)
                .fill(Color.white)
        }
    }
    
    private var categoryText: Text {
        Text(floatingCategory.toKorean())
            .font(.Body2_medium)
            .foregroundStyle(Color.gray900)
    }
    
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
                .frame(width: 32, height: 32)
                .blur(radius: 4)
            
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

struct FloatingCategory_Preview: PreviewProvider {
    static var previews: some View {
        FloatingCategory(floatingCategory: .part(.teeth))
    }
}
