//
//  SRCLogUtils.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import Foundation

public func printEnterLog(_ file: String = #file, function: StaticString = #function) {
    print("Entering \(getFileAndFunctionTitle(file: file, function: function))")
}

public func printExitLog(_ file: String = #file, function: StaticString = #function) {
    print("Exiting \(getFileAndFunctionTitle(file: file, function: function))")
}

public func getFileAndFunctionTitle(file: String = #file, function: StaticString = #function) -> String {
    var fileName = file

    if let url = URL(string: file) {
        let name = url.lastPathComponent
        fileName = name
    }
    
    return "\(fileName):\(function)"
}
