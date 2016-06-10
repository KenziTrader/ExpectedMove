//
//  CalculateExpectedMoveWorkerTest.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/9/16.
//  Copyright © 2016 Rene Laterveer. All rights reserved.
//

import Foundation

@testable import ExpectedMove
import XCTest

class CalculateExpectedMoveWorkerTest: XCTestCase
{
    // MARK: Subject under test
    
    var sut: CalculateExpectedMoveWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupCalculateExpectedMoveWorkerTest()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupCalculateExpectedMoveWorkerTest()
    {
        sut = CalculateExpectedMoveWorker()
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testCalculateShouldReturnProfitLoss()
    {
        // Given
        
        // When
        let numberOfShares = 100
        let impliedVolatility = 19.7 / 100
        let price = 99.90
        let profitLoss = sut.calculate(price, numberOfShares: numberOfShares, impliedVolatility: impliedVolatility)
        let profit = profitLoss.map {$0.profit}
        let expected = [103.011, 145.680, 178.421, 272.543]
        // check if the results are equal up to 3 digits after the decimal point
        let allEqual = zip(profit, expected).map{round(($0.0 - $0.1)*1.0E3)}.reduce(true){$0 && $1==0.0}
        
        // Then
        XCTAssert(allEqual, "CalculateExpectedMoveWorker should return correct profit for the example data")
        
    }
}

