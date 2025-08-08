//
//  UIWindow+Transition.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import Foundation
import UIKit

extension UIWindow {
    
    enum Transition {
        case fade
        case reveal
        case push
        case pop
    }
    
    func animate(transitionType: Transition) {
        let transition = CATransition()
        transition.duration = 0.25
        switch transitionType {
        case .fade:
            transition.type = CATransitionType.fade
        case .reveal:
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
        case .push:
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromRight
        case .pop:
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromLeft
        }
        self.layer.add(transition, forKey: kCATransition)
    }
}
