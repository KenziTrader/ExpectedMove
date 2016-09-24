//
//  FinanceDataAPI.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/9/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

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
        financeData.changeFromYearHigh          = double(quote["ChangeFromYearHigh"])
        financeData.changeFromYearLow           = double(quote["ChangeFromYearLow"])
        financeData.changeinPercent             = percentToDouble(quote["ChangeinPercent"])
        financeData.currency                    = string(quote["Currency"])
        financeData.daysHigh                    = double(quote["DaysHigh"])
        financeData.daysLow                     = double(quote["DaysLowsk"])
        financeData.daysRange                   = string(quote["DaysRange"])
        financeData.daysValueChange             = double(quote["DaysValueChange"])
        financeData.dividendPayDate             = date(quote["DividendPayDate"])
        financeData.dividendShare               = double(quote["DividendShare"])
        financeData.dividendYield               = double(quote["DividendYield"])
        financeData.earningsShare               = double(quote["EarningsShare"])
        financeData.EBITDA                      = string(quote["EBITDA"])
        financeData.EPSEstimateCurrentYear      = double(quote["EPSEstimateCurrentYear"])
        financeData.EPSEstimateNextQuarter      = double(quote["EPSEstimateNextQuarter"])
        financeData.EPSEstimateNextYear         = double(quote["EPSEstimateNextYear"])
        financeData.exDividendDate              = date(quote["ExDividendDate"])
        financeData.fiftydayMovingAverage       = double(quote["FiftydayMovingAverage"])
        financeData.highLimit                   = string(quote["HighLimit"])
        financeData.lastTradeDate               = date(quote["LastTradeDate"])
        financeData.lastTradePrice              = double(quote["LastTradePriceOnly"])
        financeData.lastTradeTime               = date(quote["LastTradeTime"])
        financeData.lowLimit                    = string(quote["LowLimit"])
        financeData.marketCapitalization        = string(quote["MarketCapitalization"])
        financeData.name                        = string(quote["Name"])
        financeData.oneyrTargetPrice            = double(quote["OneyrTargetPrice"])
        financeData.open                        = double(quote["Open"])
        financeData.PEGRatio                    = double(quote["PEGRatio"])
        financeData.PERatio                     = double(quote["PERatio"])
        financeData.PERatioRealtime             = double(quote["PERatioRealtime"])
        financeData.percebtChangeFromYearHigh   = percentToDouble(quote["PercebtChangeFromYearHigh"])
        financeData.percentChange               = percentToDouble(quote["PercentChange"])
        financeData.percentChangeFromYearLow    = percentToDouble(quote["PercentChangeFromYearLow"])
        financeData.previousClose               = double(quote["PreviousClose"])
        financeData.priceBook                   = double(quote["PriceBook"])
        financeData.priceEPSEstimateCurrentYear = double(quote["PriceEPSEstimateCurrentYear"])
        financeData.priceEPSEstimateNextYear    = double(quote["PriceEPSEstimateNextYear"])
        financeData.priceSales                  = double(quote["PriceSales"])
        financeData.shortRatio                  = double(quote["ShortRatio"])
        financeData.stockExchange               = string(quote["StockExchange"])
        financeData.symbol                      = string(quote["Symbol"])
        financeData.tradeDate                   = date(quote["TradeDate"])
        financeData.twoHundreddayMovingAverage  = double(quote["TwoHundreddayMovingAverage"])
        financeData.volume                      = int(quote["AVolume"])
        financeData.yearHigh                    = double(quote["YearHigh"])
        financeData.yearLow                     = double(quote["YearLow"])
       
        
        return financeData
    }
    
    private func double(x: AnyObject?) -> Double? {
        return (x as? String)?.asDouble()
    }
    
    private func percentToDouble(x: AnyObject?) -> Double? {
        return (x as? String)?.percentToDouble()
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
