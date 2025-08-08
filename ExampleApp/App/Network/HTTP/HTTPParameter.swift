//
//  HTTPParameter.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.02.2025.
//


import Foundation

public struct HTTPParameter {
    let key: String
    let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
