//
//  NBUItemCell.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 19.10.2021.
//

import UIKit

// MARK: - Class Implementation

class NBUItemCell: UITableViewCell {
    
    // MARK: Properties
    
    var currenciesViewController: CurrenciesViewController?

    // MARK: Outlets
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightTopLabel: UILabel!
    @IBOutlet weak var rightBottomLabel: UILabel!
}

// MARK: - Internal

internal extension NBUItemCell {
    
    func setupCell(cellType: NBUCellType) {
        switch cellType {
        case let .currency(_, leftText, rightTopText, rightBottomText):
            leftLabel.textColor = .black
            rightTopLabel.textColor = .black
            rightBottomLabel.textColor = .lightGray
            rightBottomLabel.adjustsFontSizeToFitWidth = true
            rightTopLabel.adjustsFontSizeToFitWidth = true
            
            leftLabel.text = leftText
            rightTopLabel.text = rightTopText
            rightBottomLabel.text = rightBottomText
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "lightBlue")
        selectedBackgroundView = bgColorView
    }
}
