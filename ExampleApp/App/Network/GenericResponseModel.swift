//
//  GenericResponseModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 21.12.2024.
//

import Foundation

struct GenericResponseModel<T: Codable>: Codable {
    let ErrorCode: Int?
    let Result: Bool?
    let Message: String?
    let Body: T?
}

