//
//  Font+Extension.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.01.2025.
//

import SwiftUI

extension Font {
    static func axiforma(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Axiforma", size: size).weight(weight)
    }
}
