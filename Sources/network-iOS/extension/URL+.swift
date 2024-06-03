//
//  File.swift
//  
//
//  Created by Jihee hwang on 6/3/24.
//

import Foundation

public extension URL {
    func appendingQueryItems(_ items: [URLQueryItem]) -> Self {
        var urlComponent = URLComponents(
            url: self,
            resolvingAgainstBaseURL: true
        )
        
        urlComponent?.queryItems = items
        return urlComponent?.url ?? self
    }
}
