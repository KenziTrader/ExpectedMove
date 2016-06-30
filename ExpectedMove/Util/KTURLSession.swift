//
//  KTURLSession.swift
//  ExpectedMove
//
//  Created by Rene on 28/06/16.
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

