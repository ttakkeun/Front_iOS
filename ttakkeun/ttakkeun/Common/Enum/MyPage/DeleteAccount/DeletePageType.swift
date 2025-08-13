//
//  DeletePageType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation

enum DeletePageType {
    case firstPage
    case secondPage
    
    static var firstPageContents: String {
        return """
              [회원 탈퇴 시 유의사항]

                1. 데이터 삭제
                * 회원 탈퇴를 신청하면 사용자의 모든 개인정보 및 반려동물 프로필 정보, 서비스 이용 내역이 영구적으로 삭제됩니다.
                * 단, 사용자가 작성한 게시글은 작성자 이름이 가려진 상태로 남아있을 수 있으며, 게시글 내용은 삭제되지 않습니다.
                * 삭제된 데이터는 복구할 수 없으니 신중히 결정해 주시기 바랍니다.

                2. 서비스 이용 제한 및 재가입
                * 탈퇴 완료 시 서비스 이용이 중단되며, 관련 정보도 삭제됩니다.
                * 회원 탈퇴 후 동일한 이메일 주소로 재가입이 가능하지만, 이전에 사용했던 데이터는 복구되지 않으며, 새로운 계정으로 서비스 이용을 시작하게 됩니다.

                3. 재가입
                * 회원 탈퇴 후에는 동일한 이메일 주소로 재가입이 가능합니다. 다만, 이전 가입 시의 데이터는 유지되지 않으며, 새로운 계정으로 서비스 이용을 시작하게 됩니다.
            """
    }
}
