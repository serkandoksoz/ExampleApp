//
//  VoidResult.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.02.2025.
//


import Foundation

public enum VoidResult<T: Error> {
    case success
    case failure(T)
}
