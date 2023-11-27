//
//  DataProviderQueryOptions.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation

struct DataProviderQueryOptions: OptionSet {
    let rawValue: Int
    
    static let notFiltered = DataProviderQueryOptions(rawValue: 1 << 0)
    static let notSorted = DataProviderQueryOptions(rawValue: 1 << 1)
    static let notLimited = DataProviderQueryOptions(rawValue: 1 << 2)
}

extension DataProviderQueryOptions {
    static let `default`: DataProviderQueryOptions = []
}

extension DataProviderQueryOptions {
    var isFiltered: Bool {
        return !self.contains(.notFiltered)
    }
    
    var isSorted: Bool {
        return !self.contains(.notSorted)
    }
    
    var isLimited: Bool {
        return !self.contains(.notLimited)
    }
}
