//
//  RequestDecodable.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.02.2025.
//


import Foundation

public protocol RequestDecodable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public struct RequestDecoder: RequestDecodable {
    public init() {}
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkingError.couldNotParse
        }
    }
}
