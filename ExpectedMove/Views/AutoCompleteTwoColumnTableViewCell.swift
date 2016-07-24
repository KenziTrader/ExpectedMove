//
//  AutoCompleteTwoColumnTableViewCell.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 23/07/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import UIKit

class AutoCompleteTwoColumnTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialization code
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        commonInit()
    }
    
    private func commonInit() {
        
        let tickerWidth = 75
        
        textLabel?.font = UIFont.systemFontOfSize(TickerAutoCompleteTextField.fontSize)
        nameLabel.font = UIFont.systemFontOfSize(TickerAutoCompleteTextField.fontSize)

        // Add the labels to the cell
        contentView.addSubview(nameLabel)
        
        let views = ["tickerLabel": textLabel!,
                     "nameLabel": nameLabel]
        
        let contraintFormats = [
            "H:|-[tickerLabel(\(tickerWidth))][nameLabel]-|",
            "V:|[tickerLabel]|",
            "V:|[nameLabel]|"
        ]
        
        var allConstraints = [NSLayoutConstraint]()
        
        for constraintFormat in contraintFormats {
            let constraint = NSLayoutConstraint.constraintsWithVisualFormat(
                constraintFormat,
                options: [],
                metrics: nil,
                views: views)
            allConstraints += constraint
        }
    
        NSLayoutConstraint.activateConstraints(allConstraints)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(ticker: NSAttributedString, name: String) {
        textLabel?.attributedText = ticker
        nameLabel.text = name
        // TODO: set colors, etc.
        // textLabel?.backgroundColor = UIColor.yellowColor()
        // nameLabel.backgroundColor = UIColor.magentaColor()
    }

}
