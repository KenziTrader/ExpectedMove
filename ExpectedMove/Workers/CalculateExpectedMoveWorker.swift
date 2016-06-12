//
//  CalculateExpectedMoveWorker.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/9/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

// MARK: - Calculate Expexted Move worker

struct ProfitLoss {
    var ndays: Int
    var loss: Double
    var profit: Double
}

class CalculateExpectedMoveWorker
{

    func calculate(price: Double, numberOfShares: Int, impliedVolatility: Double) -> [ProfitLoss]
    {
        var profitLosses = [ProfitLoss]()
        let numberDays = [1, 2, 3, 7]
        for days in numberDays {
            let profit = price * Double(numberOfShares) * impliedVolatility * sqrt(Double(days)/365)
            let profitLoss = ProfitLoss(ndays: days, loss: -profit, profit: profit)
            profitLosses.append(profitLoss)
        }
        return profitLosses
    }
}
