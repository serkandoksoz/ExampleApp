//
//  DataHelper.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.01.2025.
//

import Foundation

class DataHelper {
    public static func DictionaryToData(payload: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: payload, options: [])
    }
}
