//
//  TickerAutoCompleteTextField.swift
//  ExpectedMove
//
//  Created by Rene on 30/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import UIKit

class TickerAutoCompleteTextField: AutoCompleteTextField {
    
    static let fontSize: CGFloat = 14

    /// The strings to be shown on as suggestions, set this before setting
    /// autoCompleteStrings as it doesn't reload the tableview
    var descriptionStrings: [String]?
    
    func setup()
    {
        autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autoCompleteTextFont = UIFont.systemFontOfSize(TickerAutoCompleteTextField.fontSize)
        autoCompleteCellHeight = 25.0
        maximumAutoCompleteCount = 5
        hidesWhenSelected = true
        hidesWhenEmpty = true
        enableAttributedText = true
        clearButtonMode = .Never
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont.boldSystemFontOfSize(TickerAutoCompleteTextField.fontSize)
        autoCompleteAttributes = attributes
    }
    
    func configure(cell: AutoCompleteTwoColumnTableViewCell, indexPath: NSIndexPath)
    {
        if let ticker = autoCompleteStrings?[indexPath.row],
            let name = descriptionStrings?[indexPath.row]
        {
            // we have to redo the work of AutoCompleteTextField
            // because Swift doesn't have protected properties
            
            let attrs = [NSForegroundColorAttributeName: autoCompleteTextColor,
                         NSFontAttributeName: autoCompleteTextFont]
            let tickerAttributed = NSMutableAttributedString(string: ticker, attributes: attrs)
            
            let str = ticker as NSString
            let selectedRange = str.rangeOfString(text!, options: .CaseInsensitiveSearch)
            tickerAttributed.addAttributes(autoCompleteAttributes!, range: selectedRange)
            
            cell.configure(tickerAttributed, name: name)
        }
        
        cell.contentView.gestureRecognizers = nil

    }

}
