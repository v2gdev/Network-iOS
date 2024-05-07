//
//  File.swift
//  
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

extension Error {
    public var asNetworkError: NetworkError? {
        self as? NetworkError
    }
    
    public func networkError(
        orFailWith message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> NetworkError {
        guard let networkError = self as? NetworkError else {
            fatalError(message(), file: file, line: line)
        }
        
        return networkError
    }

    func networkError(or defaultAFError: @autoclosure () -> NetworkError) -> NetworkError {
        self as? NetworkError ?? defaultAFError()
    }
}
