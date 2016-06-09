//
//  FetchTickerWorkerTests.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/9/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

@testable import ExpectedMove
import XCTest

class FetchTickerWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: FetchTickerWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupFetchTickerWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupFetchTickerWorker()
    {
        sut = FetchTickerWorker(financeDataService: FinanceDataFromMemorySpy())
    }
    
    // MARK: Test doubles
    
    class FinanceDataFromMemorySpy: FinanceDataFromMemory
    {
        // MARK: Method call expectations
        var fetchTickerCalled = false
        
        // MARK: Spied methods
        override func fetchTicker(ticker: String, completionHandler: (financeData: FinanceData) -> Void)
        {
            fetchTickerCalled = true
            let oneSecond = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(oneSecond, dispatch_get_main_queue(), {
                completionHandler(financeData: FinanceData())
            })
        }
    }

    // MARK: Tests
    
    func testFetchTickerShouldReturnFinanceData()
    {
        // Given
        let financeDataFromMemorySpy = sut.financeDataService as! FinanceDataFromMemorySpy
        
        // When
        let expectation = expectationWithDescription("Wait for fetchTicker() to return")
        let ticker = "AAPL"
        sut.fetchTicker(ticker) { (financeData) in
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(financeDataFromMemorySpy.fetchTickerCalled, "Calling fetchTicker() should ask to get financial data")
        waitForExpectationsWithTimeout(1.1) { (error) in
            XCTAssert(true, "Calling fetchTicker() should result in the completion handler being called with the financial data")
        }
    }
}

