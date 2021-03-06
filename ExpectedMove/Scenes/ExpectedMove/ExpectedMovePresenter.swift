//
//  ExpectedMovePresenter.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/8/16.
//  Copyright (c) 2016 Rene Laterveer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ExpectedMovePresenterInput
{
    func presentProfitLossDaysAhead(response: ExpectedMove.FetchTicker.Response)
    func setNetworkActivityIndicatorVisible(visible: Bool)
    func presentStockAutoComplete(response: ExpectedMove.AutoComplete.Response)
}

protocol ExpectedMovePresenterOutput: class
{
    func displayProfitLossDaysAhead(viewModel: ExpectedMove.FetchTicker.ViewModel)
    func displayStockAutoComplete(viewModel: ExpectedMove.AutoComplete.ViewModel)
    func setNetworkActivityIndicatorVisible(visible: Bool)
}

class ExpectedMovePresenter: ExpectedMovePresenterInput
{
    weak var output: ExpectedMovePresenterOutput!
    let priceFormatter: NSNumberFormatter = {
        let priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .DecimalStyle
        priceFormatter.roundingIncrement = 0.01
        priceFormatter.minimumFractionDigits = 2
        priceFormatter.maximumFractionDigits = 2
        return priceFormatter
    }()
    let profitLossFormatter: NSNumberFormatter = {
        let profitLossFormatter = NSNumberFormatter()
        profitLossFormatter.numberStyle = .DecimalStyle
        profitLossFormatter.positiveFormat = "+"
        profitLossFormatter.negativeFormat = "-"
        profitLossFormatter.roundingIncrement = 1.0
        return profitLossFormatter
    }()
    
    // MARK: Presentation logic
    
    func presentProfitLossDaysAhead(response: ExpectedMove.FetchTicker.Response)
    {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        
        let price = response.price
        let displayedPrice = priceFormatter.stringFromNumber(price)
        
        var displayedProfitLosses: [ExpectedMove.FetchTicker.DisplayedProfitLoss] = []

        for profitLoss in response.profitLoss {
            let loss = profitLossFormatter.stringFromNumber(profitLoss.loss)
            let profit = profitLossFormatter.stringFromNumber(profitLoss.profit)
            let displayedProfitLoss = ExpectedMove.FetchTicker.DisplayedProfitLoss(ndays: profitLoss.ndays, loss: loss!, profit: profit!)
            displayedProfitLosses.append(displayedProfitLoss)
        }

        let viewModel = ExpectedMove.FetchTicker.ViewModel(price: displayedPrice!, expectedProfitLossDaysAhead: displayedProfitLosses)
        output.displayProfitLossDaysAhead(viewModel)
    }
    
    func setNetworkActivityIndicatorVisible(visible: Bool) {
        output.setNetworkActivityIndicatorVisible(visible)
    }
    
    func presentStockAutoComplete(response: ExpectedMove.AutoComplete.Response)
    {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        
        var displayedAutoCompleteResults: [ExpectedMove.AutoComplete.DisplayedStockAutoCompleteResult] = []
        
        // loop over all non-option autocomplete results
        for autoCompleteResult in response.autoCompleteResults where autoCompleteResult.type != "Option"
        {
            let symbol = autoCompleteResult.symbol!
            let name = autoCompleteResult.name!

            let displayedAutoCompleteResult =
                ExpectedMove.AutoComplete.DisplayedStockAutoCompleteResult(ticker: symbol, name: name)
            displayedAutoCompleteResults.append(displayedAutoCompleteResult)
        }
        
        let viewModel = ExpectedMove.AutoComplete.ViewModel(autoCompleteResults: displayedAutoCompleteResults)
        output.displayStockAutoComplete(viewModel)
    }
}
