//
//  PrivateBankItemCell.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 19.10.2021.
//

import UIKit

// MARK: - Class Implementation

class PrivateBankItemCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
}

// MARK: - Internal

internal extension PrivateBankItemCell {
    
    func setupCell(cellType: PrivateBankCellType) {
        
        switch cellType {
        case let .currency(_, leftText, middleText, rightText):
            leftLabel.textColor = .black
            middleLabel.textColor = .black
            rightLabel.textColor = .black
            middleLabel.adjustsFontSizeToFitWidth = true
            rightLabel.adjustsFontSizeToFitWidth = true

            
            leftLabel.text = leftText
            middleLabel.text = middleText
            rightLabel.text = rightText
            
            let bgView = UIView()
            bgView.backgroundColor = UIColor(named: "lightBlue")
            selectedBackgroundView = bgView
            selectionStyle = .default
            
        case let .header(leftText, middleText, rightText):
            leftLabel.textColor = .lightGray
            middleLabel.textColor = .lightGray
            rightLabel.textColor = .lightGray
            
            leftLabel.text = leftText
            middleLabel.text = middleText
            rightLabel.text = rightText
            
            selectionStyle = .none
        }
    }
}
