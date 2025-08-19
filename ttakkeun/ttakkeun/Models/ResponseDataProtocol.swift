//
//  ResponseDataProtocol.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/16/25.
//

import Foundation

protocol ResponseDataProtocol {
    var isSuccess: Bool { get }
    var code: String { get }
    var message: String { get }
}
