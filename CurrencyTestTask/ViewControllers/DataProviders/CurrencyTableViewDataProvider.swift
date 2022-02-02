//
//  File.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 20.10.2021.
//

import Foundation
import UIKit

// MARK: - CurrencyTableViewDataProvider

protocol CurrencyTableViewDataProvider: UITableViewDelegate, UITableViewDataSource {
    
    var delegate: DataProviderDelegate? { get set }
}
