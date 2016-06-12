//
//  FinanceDataAPITests.swift
//  ExpectedMove
//
//  Created by Rene on 12/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

@testable import ExpectedMove
import XCTest

class FinanceDataAPITests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: FinanceDataAPI!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupFinanceDataAPIService()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupFinanceDataAPIService()
    {
        sut = FinanceDataAPI()

        let json = "{\"query\":{\"count\":1,\"created\":\"2016-06-09T17:25:25Z\",\"lang\":\"en-us\",\"results\":{\"quote\":{\"symbol\":\"AAPL\",\"Ask\":\"99.81\",\"AverageDailyVolume\":\"38273600\",\"Bid\":\"99.80\",\"AskRealtime\":null,\"BidRealtime\":null,\"BookValue\":\"23.81\",\"Change_PercentChange\":\"+0.86 - +0.87%\",\"Change\":\"+0.86\",\"Commission\":null,\"Currency\":\"USD\",\"ChangeRealtime\":null,\"AfterHoursChangeRealtime\":null,\"DividendShare\":\"2.28\",\"LastTradeDate\":\"6/9/2016\",\"TradeDate\":null,\"EarningsShare\":\"8.98\",\"ErrorIndicationreturnedforsymbolchangedinvalid\":null,\"EPSEstimateCurrentYear\":\"8.28\",\"EPSEstimateNextYear\":\"9.11\",\"EPSEstimateNextQuarter\":\"1.66\",\"DaysLow\":\"98.46\",\"DaysHigh\":\"99.98\",\"YearLow\":\"89.47\",\"YearHigh\":\"132.97\",\"HoldingsGainPercent\":null,\"AnnualizedGain\":null,\"HoldingsGain\":null,\"HoldingsGainPercentRealtime\":null,\"HoldingsGainRealtime\":null,\"MoreInfo\":null,\"OrderBookRealtime\":null,\"MarketCapitalization\":\"546.65B\",\"MarketCapRealtime\":null,\"EBITDA\":\"78.50B\",\"ChangeFromYearLow\":\"10.33\",\"PercentChangeFromYearLow\":\"+11.55%\",\"LastTradeRealtimeWithTime\":null,\"ChangePercentRealtime\":null,\"ChangeFromYearHigh\":\"-33.17\",\"PercebtChangeFromYearHigh\":\"-24.95%\",\"LastTradeWithTime\":\"11:45am - <b>99.80</b>\",\"LastTradePriceOnly\":\"99.80\",\"HighLimit\":null,\"LowLimit\":null,\"DaysRange\":\"98.46 - 99.98\",\"DaysRangeRealtime\":null,\"FiftydayMovingAverage\":\"97.14\",\"TwoHundreddayMovingAverage\":\"102.61\",\"ChangeFromTwoHundreddayMovingAverage\":\"-2.81\",\"PercentChangeFromTwoHundreddayMovingAverage\":\"-2.73%\",\"ChangeFromFiftydayMovingAverage\":\"2.66\",\"PercentChangeFromFiftydayMovingAverage\":\"+2.74%\",\"Name\":\"Apple Inc.\",\"Notes\":null,\"Open\":\"98.50\",\"PreviousClose\":\"98.94\",\"PricePaid\":null,\"ChangeinPercent\":\"+0.87%\",\"PriceSales\":\"2.38\",\"PriceBook\":\"4.15\",\"ExDividendDate\":\"5/5/2016\",\"PERatio\":\"11.11\",\"DividendPayDate\":\"2/11/2016\",\"PERatioRealtime\":null,\"PEGRatio\":\"1.29\",\"PriceEPSEstimateCurrentYear\":\"12.05\",\"PriceEPSEstimateNextYear\":\"10.95\",\"Symbol\":\"AAPL\",\"SharesOwned\":null,\"ShortRatio\":\"1.18\",\"LastTradeTime\":\"11:45am\",\"TickerTrend\":null,\"OneyrTargetPrice\":\"124.90\",\"Volume\":\"12539633\",\"HoldingsValue\":null,\"HoldingsValueRealtime\":null,\"YearRange\":\"89.47 - 132.97\",\"DaysValueChange\":null,\"DaysValueChangeRealtime\":null,\"StockExchange\":\"NMS\",\"DividendYield\":\"2.31\",\"PercentChange\":\"+0.87%\"}}}}"
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
    
    func testFetchTickerShouldConvertJSON()
    {
        // Given
        let ticker = "AAPL"
        var price: Double = 0
        var name = ""
        var yearLow: Double = 0
        var yearHigh: Double = 0
        var lastTradeDate = NSDate()
        let dateComponents = NSDateComponents()
        dateComponents.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.day = 9
        let expectedDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        // When
        let expectation = expectationWithDescription("Wait for fetchTicker() to return")
        sut.fetchTicker(ticker) { (financeData: FinanceData) in
            expectation.fulfill()
            price = financeData.lastTradePrice!
            name = financeData.name!
            yearLow = financeData.yearLow!
            yearHigh = financeData.yearHigh!
            lastTradeDate = financeData.lastTradeDate!
        }
        
        // Then
        waitForExpectationsWithTimeout(0.1) { (error) in
       XCTAssertEqual(price, 99.80, "Fetch ticker from API should convert the price correctly from JSON")
        XCTAssertEqual(name, "Apple Inc.", "Fetch ticker from API should convert the name correctly from JSON")
        XCTAssertEqual(yearLow, 89.47, "Fetch ticker from API should convert the year low correctly from JSON")
        XCTAssertEqual(yearHigh, 132.97, "Fetch ticker from API should convert the year high correctly from JSON")
        XCTAssertEqual(lastTradeDate, expectedDate, "Fetch ticker from API should convert the last trade date correctly from JSON")
        }
    }
}

