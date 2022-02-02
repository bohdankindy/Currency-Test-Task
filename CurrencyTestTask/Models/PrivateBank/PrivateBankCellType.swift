//
//  PrivateBankModel.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 20.10.2021.
//

import Foundation

enum PrivateBankCellType {
    
    case header(leftText: String, middleText: String, rightText: String)
    case currency(currency: Currency, leftText: String, middleText: String, rightText: String)
}
