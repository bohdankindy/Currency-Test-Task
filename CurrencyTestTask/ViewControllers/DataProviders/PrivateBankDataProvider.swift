//
//  PrivateBankDataProvider.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 20.10.2021.
//

import Foundation
import UIKit


// MARK: - Class implementation

class PrivateBankDataProvider: NSObject, CurrencyTableViewDataProvider  {
    
    weak var delegate: DataProviderDelegate?
}

// MARK: - UITableViewDataSource

extension PrivateBankDataProvider {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.privateBankModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let delegate = delegate else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.privateBankReuseIdentifier, for: indexPath) as! PrivateBankItemCell
        
        let cellType = delegate.privateBankModel[indexPath.row]
        cell.setupCell(cellType: cellType)
        return cell
        
    }
}

// MARK: - UITableViewDelegate

extension PrivateBankDataProvider {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectPrivateBankCell(for: indexPath)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

