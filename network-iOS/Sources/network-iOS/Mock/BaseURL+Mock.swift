//
//  File.swift
//  
//
//  Created by Jihee hwang on 4/23/24.
//

import Foundation

// MARK: - 기존 충전국밥의 PrefixManager

enum APITarget {

    case payment(Payment)
    case point(Point)
    
}

// MARK: - Path Type

extension APITarget {
    
    // MARK: - Payment
    
    enum Payment: Pathable {
        case prepay
        case card_List
        case card_Delete
        
        var path: String {
            switch self {
            case .prepay:
                return "/mobile/payment/prepay"
            case .card_List:
                return "/mobile/payment/card/list"
            case .card_Delete:
                return "/mobile/payment/card/%@"
            }
        }
    }
    
    // MARK: - Point
    
    enum Point: Pathable {
        case point
        case point_History
        
        var path: String {
            switch self {
            case .point:
                return "/mobile/points"
            case .point_History:
                return "/mobile/points/histories"
            }
        }
    }
    
}

// MARK: - BaseURL

extension APITarget: BaseURL {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "evs-chungguk-dev-api.autocrypt.io"
    }
    
    var path: String {
        switch self {
        case .payment(let payment):
            return payment.path
        case .point(let point):
            return point.path
        }
    }
    
    var baseURL: URL? {
        makeBaseURL()
    }
    
}
