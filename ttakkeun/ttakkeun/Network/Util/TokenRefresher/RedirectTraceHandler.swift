//
//  RedirectTracer.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/26/25.
//

import Alamofire
import Foundation

final class RedirectTraceHandler: RedirectHandler, @unchecked Sendable {
    // 요청별로 리다이렉트 히스토리를 저장하고 싶다면 여기서 관리
    private var traces: [Int: [String]] = [:] // taskIdentifier : [log]

    func task(_ task: URLSessionTask,
              willBeRedirectedTo request: URLRequest,
              for response: HTTPURLResponse,
              completion: @escaping (URLRequest?) -> Void) {

        let fromURL = response.url?.absoluteString ?? "(unknown)"
        let toURL   = request.url?.absoluteString ?? "(unknown)"
        let line = "Redirect: [\(response.statusCode)] \(fromURL) → \(toURL)"

        var arr = traces[task.taskIdentifier, default: []]
        arr.append(line)
        traces[task.taskIdentifier] = arr
        print(line)

        // 계속 따라가려면 그대로 넘기기
        completion(request)
    }
}
