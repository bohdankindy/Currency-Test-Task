//
//  Сurreny.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 20.10.2021.
//

import Foundation

enum Currency: String {
    
    case USD = "USD"
    case EUR = "EUR"
    case RUR = "RUR"
    case BTC = "BTC"
//    case CHF = "USD"
//    case CZK = "USD"
//    case GBP = "USD"
//    case PLN = "USD"
    case invalid
    
    static func safeCurrency(rawValue: String) -> Currency {
        switch rawValue {
        case "RUR", "RUB":
            return .RUR
        default:
            return Currency(rawValue: rawValue) ?? .invalid
        }
    }
}
