//
//  StockAutoCompleteTests.swift
//  ExpectedMove
//
//  Created by Rene on 28/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

@testable import ExpectedMove
import XCTest

class StockAutoCompleteTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: StockAutoCompleteAPI!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupStockAutoCompleteAPIService()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupStockAutoCompleteAPIService()
    {
        sut = StockAutoCompleteAPI()
        
        let json = "{\"ResultSet\":{\"Query\":\"AAP\",\"Result\":[{\"symbol\":\"AAP\",\"name\":\"Advance Auto Parts Inc.\",\"exch\":\"NYQ\",\"type\":\"S\",\"exchDisp\":\"NYSE\",\"typeDisp\":\"Equity\"},{\"symbol\":\"AAPL\",\"name\":\"Apple Inc.\",\"exch\":\"NAS\",\"type\":\"S\",\"exchDisp\":\"NASDAQ\",\"typeDisp\":\"Equity\"},{\"symbol\":\"AAPL160715P00090000\",\"name\":\"AAPL Jul 2016 put 90.000\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"},{\"symbol\":\"AAPL160715C00097500\",\"name\":\"AAPL Jul 2016 call 97.500\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"},{\"symbol\":\"AAPL.MX\",\"name\":\"Apple Inc.\",\"exch\":\"MEX\",\"type\":\"S\",\"exchDisp\":\"Mexico\",\"typeDisp\":\"Equity\"},{\"symbol\":\"AAPL160715C00092000\",\"name\":\"AAPL160715C00092000\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"},{\"symbol\":\"AAPC\",\"name\":\"Atlantic Alliance Partnership Corp.\",\"exch\":\"NMS\",\"type\":\"S\",\"exchDisp\":\"NASDAQ\",\"typeDisp\":\"Equity\"},{\"symbol\":\"AAPL160715C00100000\",\"name\":\"AAPL Jul 2016 call 100.000\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"},{\"symbol\":\"AAPL170120P00090000\",\"name\":\"AAPL Jan 2017 put 90.000\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"},{\"symbol\":\"AAPL160715C00095000\",\"name\":\"AAPL Jul 2016 call 95.000\",\"exch\":\"OPR\",\"type\":\"O\",\"exchDisp\":\"OPR\",\"typeDisp\":\"Option\"}]}}"
        let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
        
        sut.session = NSURLSessionMock(data: jsonData, response: nil, error: nil)
    }
    
    // MARK: Test doubles
    
    class NSURLSessionMock: KTURLSession {
        
        var url: NSURL?
        var request: NSURLRequest?
        private let dataTaskMock: URLSessionDataTaskMock
        
        init(data: NSData?, response: NSURLResponse?, error: NSError?)
        {
            dataTaskMock = URLSessionDataTaskMock()
            dataTaskMock.taskResponse = (data: data, response: response, error: error)
        }
        
        func dataTaskWithRequest(request: NSURLRequest,
                                 completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
        {
            self.request = request
            self.dataTaskMock.completionHandler = completionHandler
            return self.dataTaskMock
        }
        
        class URLSessionDataTaskMock : NSURLSessionDataTask {
            
            typealias CompletionHandler = (NSData!, NSURLResponse!, NSError!) -> Void
            var completionHandler: CompletionHandler?
            var taskResponse: (data: NSData?, response: NSURLResponse?, error: NSError?)?
            
            override func resume() {
                completionHandler?(taskResponse?.data, taskResponse?.response, taskResponse?.error)
            }
        }
    }
    
    // MARK: Tests
    
    func testStockAutoCompleteShouldConvertJSON()
    {
        // Given
        let ticker = "AAP"
        var numberOfSymbols = 0
        var symbol = ""
        var name = ""
        var exchange = ""
        var type = "Equity"
        
        // When
        let expectation = expectationWithDescription("Wait for stockAutoComplete() to return")
        sut.stockAutoComplete(ticker) { (stockAutoComplete: [StockAutoCompleteResult]) in
            expectation.fulfill()
            numberOfSymbols = stockAutoComplete.count
            let entry = stockAutoComplete[0]
            symbol = entry.symbol!
            name = entry.name!
            exchange = entry.exchange!
            type = entry.type!
        }
        
        // Then
        waitForExpectationsWithTimeout(0.1) { (error) in
            XCTAssertEqual(numberOfSymbols, 10, "Stock Auto Complete from API should convert the array correctly from JSON")
            XCTAssertEqual(symbol, "AAP", "Stock Auto Complete from API should convert the symbol correctly from JSON")
            XCTAssertEqual(name, "Advance Auto Parts Inc.", "Stock Auto Complete from API should convert the name correctly from JSON")
            XCTAssertEqual(exchange, "NYSE", "Stock Auto Complete from API should convert the exchange correctly from JSON")
            XCTAssertEqual(type, "Equity", "Stock Auto Complete from API should convert the type correctly from JSON")
        }
    }
}

