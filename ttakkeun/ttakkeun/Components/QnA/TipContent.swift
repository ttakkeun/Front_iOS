//
//  TipContent.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI
import Kingfisher

/// Qna탭에서 TIps화면에 들어가는 컴포넌트: Tip정보가 들어있음
struct TipContent: View {
    let data: QnaTipsResponseData
    let isBestCategory: Bool
    
    @State private var isExpanded: Bool = false
    //MARK: - Init
    init(data: QnaTipsResponseData, isBestCategory: Bool = true) {
            self.data = data
            self.isBestCategory = isBestCategory
        }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            categoryAndHeart
            if isExpanded {
                expandedContent
                    .transition(.opacity)
            } else {
                contentSet
            }
            BottomInfo
        }
        .frame(maxWidth: 327)
        .padding(14)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .stroke(Color.gray400)
        )
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
    }
    
    
    /// 더보기 버튼 눌렀을때 나오는 것
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            title
                .lineLimit(nil)
            content
            tipsImage
        }
    }
    
    
    /// 카테고리와 하트버튼
    private var categoryAndHeart: some View {
        HStack{
            categorySet
            Spacer()
            heartBtn
        }
    }
    
    private var contentSet: some View {
        HStack(alignment: .top){
            TitleAndContent
                .lineLimit(3)
            Spacer()
            tipsImage
        }
    }

    /// 제목과 내용
    private var TitleAndContent: some View {
        VStack(alignment: .leading, spacing: 12){
            title
            content
            
        }
    }
    
    /// 맨 아래 사용자이름, 경과된 시간, 더보기버튼
    private var BottomInfo: some View {
        HStack{
            userNameAndElapsedTime
            Spacer()
            moreInfoBtn
        }
    }
    
    /// Category(categoryText와 뒷배경까지)
    private var categorySet: some View {
        HStack(spacing: 5) {
                  category
                      .font(.Body4_medium)
                      .frame(width: 47, height: 23)
                      .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(categoryColor))
                  
                  if isBestCategory {
                      Text("인기")
                          .font(.Body4_medium)
                          .frame(width: 47, height: 23)
                          .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.primarycolor200))
                  }
              }
    }
    
    /// 하트와 하트 수
    private var heartBtn: some View {
            Button(action: {
                print("하트누르기")}
                   , label: {
                HStack(spacing: 6){
                    Image(systemName: "heart")
                        .foregroundStyle(Color.gray600)
                    Text("\(data.heartNumber ?? 0)")
                        .foregroundStyle(Color.gray600)
                }
            })
    }
    
    /// 제목
    private var title: some View {
        Text(data.title)
            .frame(maxWidth: 210, alignment: .leading)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
        
    }
    
    /// 내용
    private var content: some View {
        Text(data.content.split(separator: "").joined(separator: "\u{200B}"))
            .frame(maxWidth: 210, alignment: .leading)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_300)
            .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var tipsImage: some View {
        if let url = URL(string: data.image ?? "") {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure{ _ in
                    print("이미지 로드 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    /// 사용자 이름과 경과된 시간
    private var userNameAndElapsedTime: some View {
        HStack{
            Text(maskUserName(data.userName))
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            Text(formatElapsedTime(data.elapsedTime))
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        }
    }
    
    
    //TODO: - 더보기 누르면 내용 아래로 펼쳐지고 레이아웃 바뀜
    /// 더보기 버튼
    private var moreInfoBtn: some View{
        Button(action: {            isExpanded.toggle()
        }, label: {
            Text("더보기")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .underline()
        })
    }
    
   
    
    //MARK: - 카테고리 Switch
    /// 이름에따라 카테고리 변경
    @ViewBuilder
    private var category: some View {
        switch data.category {
        case .ear:
            Text("귀")
        case .eye:
            Text("눈")
        case .hair:
            Text("털")
        case .claw:
            Text("발톱")
        case .tooth:
            Text("이빨")
        case .etc:
            Text("기타")
        case .best:
            Text("인기")
        default:
            Text("")
            
        }
    }
    
    /// 카테고리 뒷 배경
    private var categoryColor: Color {
        switch data.category {
        case .ear:
            Color.qnAEar
        case .eye:
            Color.afterEye
        case .hair:
            Color.afterClaw
        case .claw:
            Color.afterEye
        case .tooth:
            Color.afterTeeth
        case .best:
            Color.primarycolor200
        default:
            Color.clear
        }
    }
    
    //MARK: - Function
    /// 사용자 이름 마스킹 함수
    /// - Parameter name: 사용자 이름
    /// - Returns: 사용자 이름 가운데 *을 집어넣음
    private func maskUserName(_ name: String) -> String {
        guard name.count > 1 else { return name }
        let first = name.prefix(1)
        let last = name.suffix(1)
        return "\(first)*\(last)"
    }
    
    /// 경과 시간을 포맷팅하는 함수
    /// - Parameter minutes: 경과된 시간(minute로 받으면)
    /// - Returns: 140분이 아니라 2시간 20분처럼 시간과 분으로 알려줌
    private func formatElapsedTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)분전"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)시간 \(remainingMinutes)분전"
        }
    }
}

//MARK: - Preview
struct TipContent_Preview: PreviewProvider {
    static var previews: some View {
        TipContent(data: QnaTipsResponseData(category: .ear, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라아 진짜 미치겠다 아아아아 그만할래아아", userName: "한지강", image: "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg", elapsedTime: 140, heartNumber: 20))
            .previewLayout(.sizeThatFits)
    }
}
