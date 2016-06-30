//
//  StockAutoCompleteAPI.swift
//  ExpectedMove
//
//  Created by Rene on 28/06/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

class StockAutoCompleteAPI
{
    lazy var session: KTURLSession = NSURLSession.sharedSession()
    private var dataTask: NSURLSessionDataTask?
    
    func stockAutoComplete(ticker: String, completionHandler: (stockAutoComplete: [StockAutoCompleteResult]) -> Void)
    {
        let urlPath = "https://autoc.finance.yahoo.com/autoc?query=\(ticker)&region=2&lang=en"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSURLRequest(URL:endpoint)
        dataTask?.cancel()
        dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let stockAutoComplete = try StockAutoCompleteResult().parseYahooJSON(data)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(stockAutoComplete: stockAutoComplete)
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }
        dataTask?.resume()
    }
}

extension StockAutoCompleteResult {
    
    func parseYahooJSON(data: NSData) throws -> [StockAutoCompleteResult]
    {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
            throw JSONError.ConversionFailed
        }
        
        var stockAutoComplete = [StockAutoCompleteResult]()
        
        guard
            let query = json["ResultSet"] as? [String: AnyObject],
            let results = query["Result"] as? [[String: AnyObject]]
            else {
                return stockAutoComplete
        }
        
        for entry in results {
            var stockAutoCompleteEntry = StockAutoCompleteResult()
            stockAutoCompleteEntry.symbol   = string(entry["symbol"])
            stockAutoCompleteEntry.name     = string(entry["name"])
            stockAutoCompleteEntry.exchange = string(entry["exchDisp"])
            stockAutoCompleteEntry.type     = string(entry["typeDisp"])
            stockAutoComplete.append(stockAutoCompleteEntry)
        }
        
        return stockAutoComplete
    }
    
    private func string(x: AnyObject?) -> String? {
        return x as? String
    }
}

