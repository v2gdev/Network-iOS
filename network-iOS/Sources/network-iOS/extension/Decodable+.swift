//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension Decodable {
    
    public func decode<D>(
        _ type: D.Type,
        _ data: Data?
    ) async throws -> D where D: Decodable {
        guard let data else {
            throw NetworkError.jsonParsingFailed
        }
        
        let decodedResponse = try JSONDecoder().decode(D.self, from: data)
        return decodedResponse
    }
    
}
