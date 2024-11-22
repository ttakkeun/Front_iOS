//
//  RankRecommendation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI
import Kingfisher

struct RankRecommendation: View {
    
    @Binding var data: ProductResponse
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12, content: {
            productImageGroup
            productInfo
        })
        .frame(width: 343, height: 95)
    }
    
    private var productImageGroup: some View {
        ZStack(alignment: .bottomLeading, content: {
            productImage
            rankTag
        })
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .frame(width: 95, height: 95)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray200)
                )
        }
    }
    
    @ViewBuilder
    private var rankTag: some View {
        ZStack {
            if (0...2).contains(rank) {
                Icon.topRank.image
                    .fixedSize()
            } else {
                Icon.bottomRank.image
                    .fixedSize()
            }
            Text("\(rank + 1)")
                .font(.Detail1_bold)
                .foregroundStyle(Color.white)
        }
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(DataFormatter.shared.stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.5)
                .frame(height: 37, alignment: .topLeading)
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            Spacer().frame(height: 9)
            
            HStack {
                Spacer()
                
                likeButton
            }
        })
        .frame(width: 236, height: 95)
    }
    
    private var likeButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                toggleLike()
            }
        }, label: {
            HStack(spacing: 4, content: {
                Group {
                    Image(systemName: data.likeStatus ? "suit.heart.fill" : "suit.heart")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 17)
                    
                    Text(countText(count: data.totalLike ?? 0))
                        .frame(width: 40, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .font(.Body3_medium)
                }
                .foregroundStyle(data.likeStatus ? Color.removeBtn : Color.gray600)
            })
        })
        
    }
    
    func countText(count: Int) -> String {
        if count > 999 {
            return "999+"
        } else {
            return String(count)
        }
    }
    
    func toggleLike() {
        data.likeStatus.toggle()
            if data.likeStatus {
                data.totalLike = (data.totalLike ?? 0) + 1
            } else {
                data.totalLike = max(0, (data.totalLike ?? 0) - 1) // 최소 0
            }
        }
}
