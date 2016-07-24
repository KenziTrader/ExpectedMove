//
//  ExpectedMoveModels.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/8/16.
//  Copyright (c) 2016 Rene Laterveer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct ExpectedMove {
    struct FetchTicker {
        struct Request {
            var ticker = ""
            var numberOfShares = ""
            var impliedVolatility = ""
        }
        struct Response {
            var price: Double = 0
            var profitLoss = [ProfitLoss]()
        }
        struct ViewModel {
            var price = ""
            var expectedProfitLossDaysAhead = [DisplayedProfitLoss]()
        }
        struct DisplayedProfitLoss {
            var ndays: Int
            var loss: String
            var profit: String
        }
    }
    struct AutoComplete {
        struct Request {
            var ticker = ""
        }
        struct Response {
            var searchTerm = ""
            var autoCompleteResults = [StockAutoCompleteResult]()
        }
        struct ViewModel {
            var autoCompleteResults = [DisplayedStockAutoCompleteResult]()
        }
        struct DisplayedStockAutoCompleteResult {
            var ticker: String
            var name: String
        }
    }
}
