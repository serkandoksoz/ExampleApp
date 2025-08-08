//
//  SplashViewModel.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.01.2025.
//

import Combine
import Foundation
import UIKit

final class SplashViewModel: BaseViewModel {
    // MARK: - Published Properties
    private let repository: SplashRepository

    // Dependency Injection for Testing
    init(repository: SplashRepository = SplashRepository()) {
        self.repository = repository
    }
   
}
