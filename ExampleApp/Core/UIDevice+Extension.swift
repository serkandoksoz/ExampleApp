//
//  UIDevice+Extension.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.01.2025.
//

import UIKit

extension UIDevice {
    /// Checks if the device is iPhone SE (3rd Gen) or smaller.
    var isSmall: Bool {
        // iPhone SE 3 screen dimensions
        let se3Height: CGFloat = 667
        let se3Width: CGFloat = 375
        
        // Get the current screen size
        let screenSize = UIScreen.main.bounds.size
        let height = max(screenSize.height, screenSize.width)
        let width = min(screenSize.height, screenSize.width)
        
        // Compare screen dimensions
        return height <= se3Height && width <= se3Width
    }
}
