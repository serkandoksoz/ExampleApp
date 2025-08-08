//
//  HTTPHeaderEncoder.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.02.2025.
//


import Foundation

public protocol HTTPHeaderEncoder {
   func encodeHeaders(for urlRequest: inout URLRequest, with headers: [HTTPHeader])
}

public struct HTTPHeaderEncoderImpl: HTTPHeaderEncoder {
    public init() {}

    public func encodeHeaders(for urlRequest: inout URLRequest, with headers: [HTTPHeader]) {
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
