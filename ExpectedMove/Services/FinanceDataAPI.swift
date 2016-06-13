//
//  FinanceDataAPI.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/9/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

protocol KTURLSession {
    func dataTaskWithRequest(request: NSURLRequest,
                             completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
}

extension NSURLSession: KTURLSession { }

class FinanceDataAPI: FinanceDataProtocol
{
    lazy var session: KTURLSession = NSURLSession.sharedSession()
    
    func fetchTicker(ticker: String, completionHandler: (financeData: FinanceData) -> Void)
    {
        let urlPath = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22\(ticker)%22)&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSURLRequest(URL:endpoint)
        session.dataTaskWithRequest(request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let financeData = try FinanceData().parseYahooJSON(data)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(financeData: financeData)
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
}

extension FinanceData {
    
    func parseYahooJSON(data: NSData) throws -> FinanceData
    {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
            throw JSONError.ConversionFailed
        }

        var financeData = self

        guard
            let query = json["query"] as? [String: AnyObject],
            let results = query["results"] as? [String: AnyObject],
            let quote = results["quote"] as? [String: AnyObject]
            else {
                return financeData
        }
        
        financeData.ask                         = double(quote["Ask"])
        financeData.averageDailyVolume          = int(quote["AverageDailyVolume"])
        financeData.bid                         = double(quote["Bid"])
        financeData.bookValue                   = double(quote["BookValue"])
        financeData.change                      = double(quote["Change"])
        financeData.currency                    = string(quote["Currency"])
        financeData.dividendShare               = double(quote["DividendShare"])
        financeData.lastTradeDate               = date(quote["LastTradeDate"])
        financeData.tradeDate                   = date(quote["TradeDate"])
        financeData.earningsShare               = double(quote["EarningsShare"])
        financeData.EPSEstimateCurrentYear      = double(quote["EPSEstimateCurrentYear"])
        financeData.EPSEstimateNextYear         = double(quote["EPSEstimateNextYear"])
        financeData.EPSEstimateNextQuarter      = double(quote["EPSEstimateNextQuarter"])
        financeData.daysLow                     = double(quote["DaysLowsk"])
        financeData.daysHigh                    = double(quote["DaysHigh"])
        financeData.yearLow                     = double(quote["YearLow"])
        financeData.yearHigh                    = double(quote["YearHigh"])
        financeData.marketCapitalization        = string(quote["MarketCapitalization"])
        financeData.EBITDA                      = string(quote["EBITDA"])
        financeData.changeFromYearLow           = double(quote["ChangeFromYearLow"])
        financeData.percentChangeFromYearLow    = double(quote["PercentChangeFromYearLow"])
        financeData.changeFromYearHigh          = double(quote["ChangeFromYearHigh"])
        financeData.percebtChangeFromYearHigh   = double(quote["PercebtChangeFromYearHigh"])
        financeData.lastTradePrice              = double(quote["LastTradePriceOnly"])
        financeData.highLimit                   = string(quote["HighLimit"])
        financeData.lowLimit                    = string(quote["LowLimit"])
        financeData.daysRange                   = string(quote["DaysRange"])
        financeData.fiftydayMovingAverage       = double(quote["FiftydayMovingAverage"])
        financeData.twoHundreddayMovingAverage  = double(quote["TwoHundreddayMovingAverage"])
        financeData.name                        = string(quote["Name"])
        financeData.open                        = double(quote["Open"])
        financeData.previousClose               = double(quote["PreviousClose"])
        financeData.changeinPercent             = double(quote["ChangeinPercent"])
        financeData.priceSales                  = double(quote["PriceSales"])
        financeData.priceBook                   = double(quote["PriceBook"])
        financeData.exDividendDate              = date(quote["ExDividendDate"])
        financeData.PERatio                     = double(quote["PERatio"])
        financeData.dividendPayDate             = date(quote["DividendPayDate"])
        financeData.PERatioRealtime             = double(quote["PERatioRealtime"])
        financeData.PEGRatio                    = double(quote["PEGRatio"])
        financeData.priceEPSEstimateCurrentYear = double(quote["PriceEPSEstimateCurrentYear"])
        financeData.priceEPSEstimateNextYear    = double(quote["PriceEPSEstimateNextYear"])
        financeData.symbol                      = string(quote["Symbol"])
        financeData.shortRatio                  = double(quote["ShortRatio"])
        financeData.lastTradeTime               = date(quote["LastTradeTime"])
        financeData.oneyrTargetPrice            = double(quote["OneyrTargetPrice"])
        financeData.volume                      = int(quote["AVolume"])
        financeData.daysValueChange             = double(quote["DaysValueChange"])
        financeData.stockExchange               = string(quote["StockExchange"])
        financeData.dividendYield               = double(quote["DividendYield"])
        financeData.percentChange               = double(quote["PercentChange"])
       
        
        return financeData
    }
    
    private func double(x: AnyObject?) -> Double? {
        return (x as? String)?.asDouble()
    }
    
    private func int(x: AnyObject?) -> Int? {
        return (x as? String)?.asInt()
    }

    private func string(x: AnyObject?) -> String? {
        return x as? String
    }

    private func date(x: AnyObject?) -> NSDate? {
        return (x as? String)?.asDate()
    }
}

extension String {

    // create formatters only once
    struct Static {
        static let numberFormatter = NSNumberFormatter()
        static let nsDateFormatter = NSDateFormatter()
    }

    func asDouble() -> Double? {
        // use right decimal separator
        Static.numberFormatter.decimalSeparator = "."
        Static.numberFormatter.usesGroupingSeparator = true
        Static.numberFormatter.groupingSeparator = ","
        Static.numberFormatter.groupingSize = 3
        return Static.numberFormatter.numberFromString(self)?.doubleValue
    }

    func percentToDouble() -> Double? {
        // use right decimal separator
        Static.numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
        Static.numberFormatter.numberStyle = .PercentStyle
        return Static.numberFormatter.numberFromString(self)?.doubleValue
    }

    func asInt() -> Int? {
        // use right decimal separator
        return Static.numberFormatter.numberFromString(self)?.integerValue
    }
    
    func asDate() -> NSDate {
        Static.nsDateFormatter.dateFormat = "MM/dd/yy"
        Static.nsDateFormatter.timeZone = NSTimeZone(name: "UTC")
        // Add the locale if required here
        if let dateObj = Static.nsDateFormatter.dateFromString(self) {
            return NSDate(timeInterval:0, sinceDate:dateObj)
        } else {
            // could not parse date string
            return NSDate(timeIntervalSinceReferenceDate:0)
        }
    
    }
}

