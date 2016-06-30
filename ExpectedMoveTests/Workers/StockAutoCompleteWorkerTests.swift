//
//  StockAutoCompleteWorkerTests.swift
//  ExpectedMove
//
//  Created by Rene on 28/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

@testable import ExpectedMove
import XCTest

class StockAutoCompleteWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: StockAutoCompleteWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupStockAutoCompleteWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupStockAutoCompleteWorker()
    {
        sut = StockAutoCompleteWorker(stockAutoCompleteService: StockAutoCompleteAPISpy())
    }
    
    // MARK: Test doubles
    
    class StockAutoCompleteAPISpy: StockAutoCompleteAPI
    {
        // MARK: Method call expectations
        var stockAutoCompleteCalled = false
        
        // MARK: Spied methods
        
        override func stockAutoComplete(ticker: String, completionHandler: (stockAutoComplete: [StockAutoCompleteResult]) -> Void)
        {
            stockAutoCompleteCalled = true
            let oneSecond = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(oneSecond, dispatch_get_main_queue(), {
                completionHandler(stockAutoComplete: [StockAutoCompleteResult]())
            })
        }
    }
    
    // MARK: Tests
    
    func testStockAutoCompleteAPIShouldReturnStockAutoCompleteResultArray()
    {
        // Given
        let stockAutoCompleteAPISpy = sut.stockAutoCompleteService as! StockAutoCompleteAPISpy
        
        // When
        let expectation = expectationWithDescription("Wait for stockAutoComplete() to return")
        let ticker = "AAP"
        sut.stockAutoComplete(ticker) { (stockAutoComplete) in
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(stockAutoCompleteAPISpy.stockAutoCompleteCalled, "Calling stockAutoComplete() should ask to get auto complete the ticker")
        waitForExpectationsWithTimeout(1.1) { (error) in
            XCTAssert(true, "Calling stockAutoComplete() should result in the completion handler being called with the auto completion data")
        }
    }
}

