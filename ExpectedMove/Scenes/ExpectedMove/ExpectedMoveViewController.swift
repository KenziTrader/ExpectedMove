//
//  ExpectedMoveViewController.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/8/16.
//  Copyright (c) 2016 Rene Laterveer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ExpectedMoveViewControllerInput
{
    func displayProfitLossDaysAhead(viewModel: ExpectedMove.FetchTicker.ViewModel)
    func displayStockAutoComplete(viewModel: ExpectedMove.AutoComplete.ViewModel)
    func setNetworkActivityIndicatorVisible(visible: Bool)
}

protocol ExpectedMoveViewControllerOutput
{
    func fetchTicker(request: ExpectedMove.FetchTicker.Request)
    func autoComplete(request: ExpectedMove.AutoComplete.Request)
}

class ExpectedMoveViewController: UIViewController, ExpectedMoveViewControllerInput
{
    var output: ExpectedMoveViewControllerOutput!
    var router: ExpectedMoveRouter!
    
    private var autoCompleteResults: [ExpectedMove.AutoComplete.DisplayedStockAutoCompleteResult] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var tickerTextField: TickerAutoCompleteTextField!
    @IBOutlet weak var numberOfSharesTextField: UITextField!
    @IBOutlet weak var impliedVolatilityTextField: UITextField!
    @IBOutlet weak var displayedPriceLabel: UILabel!
    @IBOutlet var profitLosslabels: [UILabel]!
    @IBOutlet weak var calculateButton: UIButton!
    
    // MARK: Object lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        ExpectedMoveConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomethingOnLoad()
    }
    
    // MARK: Actions
    
    @IBAction func calculateButtonTapped() {
        let request = ExpectedMove.FetchTicker.Request(
            ticker: tickerTextField.text!,
            numberOfShares: numberOfSharesTextField.text!,
            impliedVolatility: impliedVolatilityTextField.text!)
        output.fetchTicker(request)
    }
    
    // MARK: Event handling
    
    func doSomethingOnLoad()
    {
        enableOrDisableCalculateButton()
        tickerTextField.setup()
        handleTextFieldInterfaces()
        // NOTE: Ask the Interactor to do some work
    }
    
    private func handleTextFieldInterfaces()
    {
        tickerTextField.onTextChange = { [weak self] text in
            if !text.isEmpty {
                let request = ExpectedMove.AutoComplete.Request(ticker: text)
                self?.output.autoComplete(request)
            }
        }
        
        tickerTextField.onSelect = { [weak self] text, indexpath in
            let ticker = self?.autoCompleteResults[indexpath.row].ticker
            self?.tickerTextField.text = ticker
            print("\(text), \(indexpath)")
        }
        
        tickerTextField.configureCell = { [weak self] tableView, indexPath in
            
            let cellIdentifier = "autocompleteCellIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AutoCompleteTwoColumnTableViewCell
            if cell == nil {
                cell = AutoCompleteTwoColumnTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }

            self?.tickerTextField.configure(cell!, indexPath: indexPath)

            return cell!
        }
    }
    
    // MARK: Display logic
    
    func displayProfitLossDaysAhead(viewModel: ExpectedMove.FetchTicker.ViewModel)
    {
        // NOTE: Display the result from the Presenter
        
        self.displayedPriceLabel.text = viewModel.price
        var tag = 0
        for profitLoss in viewModel.expectedProfitLossDaysAhead {
            self.profitLosslabels[tag].text = profitLoss.loss
            tag += 1
            self.profitLosslabels[tag].text = profitLoss.profit
            tag += 1
        }
    }
    
    func displayStockAutoComplete(viewModel: ExpectedMove.AutoComplete.ViewModel)
    {
        // NOTE: Display the result from the Presenter
        autoCompleteResults = viewModel.autoCompleteResults
        tickerTextField.descriptionStrings = autoCompleteResults.map({ $0.name })
        tickerTextField.autoCompleteStrings = autoCompleteResults.map({ $0.ticker })
    }
    
    func setNetworkActivityIndicatorVisible(visible: Bool) {
        NetworkActivityIndicator.setVisible(visible)
    }
    
    func enableOrDisableCalculateButton() {
        if let ticker = tickerTextField.text,
            let numberOfShares = numberOfSharesTextField.text,
            let impliedVolatility = impliedVolatilityTextField.text
            where ticker != "" && numberOfShares != "" && impliedVolatility != ""
        {
            calculateButton.enabled = true
        } else {
            calculateButton.enabled = false
        }
    }
}

// MARK: - UITextFieldDelegate

extension ExpectedMoveViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(textField: UITextField) {
        enableOrDisableCalculateButton()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        enableOrDisableCalculateButton()
        if let ticker = textField.text {
            let request = ExpectedMove.AutoComplete.Request(ticker: ticker)
            output.autoComplete(request)
        }
        return true
    }
}
