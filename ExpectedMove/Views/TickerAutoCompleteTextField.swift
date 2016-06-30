//
//  TickerAutoCompleteTextField.swift
//  ExpectedMove
//
//  Created by Rene on 30/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import UIKit

class TickerAutoCompleteTextField: AutoCompleteTextField {

    func configureTextField()
    {
        autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autoCompleteCellHeight = 35.0
        maximumAutoCompleteCount = 5
        hidesWhenSelected = true
        hidesWhenEmpty = true
        enableAttributedText = true
        clearButtonMode = .Never
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autoCompleteAttributes = attributes
    }
    
}
