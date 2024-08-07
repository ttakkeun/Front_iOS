//
//  AnswerString.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import Foundation

enum AnswerValue: String {
    
    // MARK: - 귀 카테고리 답변
    /* 귀지가 많이 쌓여있나요? (중복) */
    case isMaxEarWax = "귀지가 많아요"
    case colorWeird = "귀지의 색이 이상해요"
    case notEarWaxColor = "귀지가 많지 않고 색도 정상이에요"
    
    /* 귀에서 악취가 나나요? */
    case isOdor = "악취가 나요"
    case notOdor = "악취가 나지 않아요"
    
    /* 귀를 흔들거나 과도하게 긁나요? */
    case earShake = "평소와 같아아요"
    case earNotShake = "평소랑 다르게 과해요"
    
    // MARK: - 눈 카테고리 답변
    
    /* 눈물이나 눈꼽이 평소보다 많거나 색이 달라졌나요(중복) */
    case eyeBallLot = "눈물이나 눈꼽이 많아졌어요"
    case eyeBallNotLot = "눈물이 너무 적어서ㅑ 눈이 뻑뻑해 보여요"
    case normalEyeBall = "눈물과 눈꼽 모두 이상 없어요"
    
    /* 눈이 붉어졌나요? 결막염, 각말 손상, 눈꺼풀 문제 등이 원인이 될 수 있어요 */
    case isEyeRed = "흰자 자체가 빨개졌어요"
    case isEyeManyRed = "흰자들의 혈관들이 더욱 크게 붉어졌어요"
    case normalEyeRed = "아무 이상 없어요"
    
    /* 눈을 크게 잘 뜨고 있나요? */
    case notOpenEye = "눈이 부어서 잘 뜨지 못해요"
    case openEye = "눈을 잘 뜨고 있어요"
    
    // MARK: - 털 카테고리 답변
    
    /* 털에 윤기가 잘 나고 있나요? */
    case notShine = "윤기가 없어요"
    case shine = "윤기가 나요"
    
    /* 평소보다 털빠짐이 심한가요? */
    case notAlopecia = "털이 많이 빠지지 않아요"
    case alopecia = "털이 많이 빠져요"
    
    /* 집중적으로 핥거나 긁는 부위가 있나요? */
    case notScratch = "해당 부위가 없어요"
    case scratch = "해당 부위가 있어요"
    
    // MARK: - 발톱 카테고리 답변
    
    /* 발톱이 너무 길거나 부러지는 현상이 보이나요? */
    case clawDiverge = "발톱이 부러지거나 갈라져요"
    case normalClawDiverge = "적당한 길이의 발톱이에요"
    
    /* 발톱이나 발에 상처나 염증이 있나요? */
    case clawWounds = "상처나 염증이 있어요"
    case notClawWounds = "상처도 염증도 없어요"
    
    /* 발바닥을 자주 핥나요? */
    case manyLick = "염증이나 질병으로 인해 자주 핥는 것 같아요"
    case notLick = "청결을 위해 핥는 것 같아요"
    
    // MARK: - 이빨 카테고리 답변
    /* 치아에 플라크, 치석, 충치가 있나요?(중복) */
    case isPlaques = "플라크가 있어요"
    case isTartar = "치석이 있어요"
    case isChung = "충치가 있어요"
    case toothFine = "아무것도 없어요"
    
    /* 잇몸이 붉거나 부어있거나 피가 나나요?(중복) */
    case swollen = "잇몸이 붉어요"
    case bleeding = "잇몸에서 피가 나요"
    case teethWobble = "치아가 흔들리거나 빠져요"
    
    /* 입냄새가 심한가요? */
    case breathe = "입냄새가 심해요"
    case notBreathe = "입냄새가 심하지 않아요"
}
