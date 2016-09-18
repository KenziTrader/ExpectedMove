//
//  NetworkActivityIndicator.swift
//  ExpectedMove
//
//  Created by Rene on 30/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import UIKit

class NetworkActivityIndicator
{
    static private var numberOfTimesNetworkActivityIndicatorSetToVisible = 0

    static func setVisible(visible: Bool) {
        if visible {
            numberOfTimesNetworkActivityIndicatorSetToVisible += 1
        } else {
            numberOfTimesNetworkActivityIndicatorSetToVisible -= 1
        }
        assert(numberOfTimesNetworkActivityIndicatorSetToVisible >= 0 ,
               "Network activity indicator was asked to hide more often than shown")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = visible
    }
}
