//
//  Session.swift
//
//
//  Created by Jihee hwang on 4/23/24.
//

import Foundation

final class NetworkAdapterImpl: NetworkAdapter {

    private let session: URLSession
    
    private var timeoutInterval: TimeInterval = 30
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// API 요청 메서드
    public func requestAPI<D: Decodable>(
        _ type: D.Type,
        request: URLRequest
    ) async throws -> D {
        let (data, response) = try await session.data(for: request)
     
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseTypeCastingFailed
        }
    
        guard validate(statusCode: httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(
                statusCode: httpResponse.statusCode,
                responseBody: data
        )}

        
        return try await data.decode(type, data)
    }
    
    public func requestMultipart<D: Decodable>(
        _ type: D.Type,
        request: URLRequest,
        multipartFormData: MultipartFormData
    ) async throws -> D {
        var request = request
        request.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")

        let (data, _) = try await session.upload(for: request, from: multipartFormData.data)
        return try await data.decode(type, data)
    }
    
    /// URL to Image
    public func requestImage(imageURLRequest: URLRequest) async throws -> Data {
        let (data, _) = try await session.data(for: imageURLRequest)
        return data
    }
    
    /// Statust Code 유효성 검사
    @discardableResult
    public func validate<S: Sequence>(
        _ sequence: S = 200..<300,
        statusCode: Int
    ) -> Bool where S.Iterator.Element == Int {
        sequence.contains(statusCode)
    }

}
