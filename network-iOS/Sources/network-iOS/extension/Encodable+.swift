//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension Encodable {
    
    public func toJson<E>(_ value: E) async throws -> Data where E: Encodable {
        try JSONEncoder().encode(value)
    }
    
}
