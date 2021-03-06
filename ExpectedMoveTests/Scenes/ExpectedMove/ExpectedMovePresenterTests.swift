//
//  ExpectedMovePresenterTests.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/8/16.
//  Copyright (c) 2016 Rene Laterveer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

@testable import ExpectedMove
import XCTest

class ExpectedMovePresenterTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: ExpectedMovePresenter!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupExpectedMovePresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupExpectedMovePresenter()
    {
        sut = ExpectedMovePresenter()
    }
    
    // MARK: Test doubles
    
    class ExpectedMovePresenterOutputSpy: ExpectedMovePresenterOutput
    {
        // MARK: Method call expectations
        var displayProfitLossDaysAheadCalled = false
        var displayStockAutoCompleteCalled = false
        
        // MARK: Argument expectations
        var fetchTickerViewModel: ExpectedMove.FetchTicker.ViewModel!
        var autoCompleteViewModel: ExpectedMove.AutoComplete.ViewModel!
        
        // MARK: Spied methods
        func displayProfitLossDaysAhead(viewModel: ExpectedMove.FetchTicker.ViewModel)
        {
            displayProfitLossDaysAheadCalled = true
            fetchTickerViewModel = viewModel
        }
        
        func displayStockAutoComplete(viewModel: ExpectedMove.AutoComplete.ViewModel) {
            displayStockAutoCompleteCalled = true
            autoCompleteViewModel = viewModel
        }
        
        func setNetworkActivityIndicatorVisible(visible: Bool) {
        }
    }
    
    func sampleFetchTickerResponse() -> ExpectedMove.FetchTicker.Response
    {
        let numberOfShares = 100
        let impliedVolatility = 19.7 / 100
        let price = 99.90
        
        let worker = CalculateExpectedMoveWorker()
        let profitLosses = worker.calculate(price, numberOfShares: numberOfShares, impliedVolatility: impliedVolatility)
        
        let response = ExpectedMove.FetchTicker.Response(price: price, profitLoss: profitLosses)
        return response
    }
    
    // MARK: Tests
    
    func testDisplayProfitLossDaysAheadShouldFormatCalculatedProfitLossForDisplay()
    {
        // Given
        let expectedMovePresenterOutputSpy = ExpectedMovePresenterOutputSpy()
        sut.output = expectedMovePresenterOutputSpy
        
        let response = sampleFetchTickerResponse()
        let expectedProfits = ["103", "146", "178", "273"]
        
        // When
        sut.presentProfitLossDaysAhead(response)
        
        // Then
        let displayedPrice = expectedMovePresenterOutputSpy.fetchTickerViewModel.price
        let displayedProfitLosses = expectedMovePresenterOutputSpy.fetchTickerViewModel.expectedProfitLossDaysAhead
        XCTAssertEqual(displayedPrice, "99.90", "Presenting fetched ticker should properly format price")
        for (displayedProfitLoss, expectedProfit) in zip(displayedProfitLosses, expectedProfits) {
            XCTAssertEqual(displayedProfitLoss.loss, "-"+expectedProfit, "Presenting fetched ticker should properly format loss")
            XCTAssertEqual(displayedProfitLoss.profit, "+"+expectedProfit, "Presenting fetched ticker should properly format profit")
        }
    }

    func testPresentFetchTickerShouldAskViewControllerToDisplayPriceAndProfitLoss()
    {
        // Given
        let expectedMovePresenterOutputSpy = ExpectedMovePresenterOutputSpy()
        sut.output = expectedMovePresenterOutputSpy
        
        let response = sampleFetchTickerResponse()
        
        // When
        sut.presentProfitLossDaysAhead(response)
        
        // Then
        XCTAssert(expectedMovePresenterOutputSpy.displayProfitLossDaysAheadCalled, "Presenting fetched ticker should ask the view controller to display them")
    }
    
    func testPresentAutoCompleteShouldAskViewControllerToDisplayAutoCompleResults()
    {
        // Given
        let expectedMovePresenterOutputSpy = ExpectedMovePresenterOutputSpy()
        sut.output = expectedMovePresenterOutputSpy
        
        let response = ExpectedMove.AutoComplete.Response()
        
        // When
        sut.presentStockAutoComplete(response)
        
        // Then
        XCTAssert(expectedMovePresenterOutputSpy.displayStockAutoCompleteCalled, "Presenting auto complete results should ask the view controller to display them")
    }
}
