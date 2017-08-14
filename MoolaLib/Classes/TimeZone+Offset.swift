//
//  TimeZone+Offset.swift
//  Prism
//
//  Created by Nguyen Le Duan on 3/30/17.
//  Copyright © 2017 Global Enterprise Mobility. All rights reserved.
//

import UIKit

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Swift.Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

let HourInSeconds = 3600
let MinuteInSeconds = 60

extension TimeZone {
    static func timeZone(offset: String) -> TimeZone? {
        let hours = offset.substring(with: 1..<3)
        let mins = offset.substring(with: 3..<5)
        var seconds = Int(hours)! * HourInSeconds + Int(mins)! * MinuteInSeconds
        if offset.substring(with: 0..<2) == "-" {
            seconds = seconds * -1
        }
        return TimeZone.init(secondsFromGMT: seconds)
    }
    
    func offsetString() -> String {
        var negative = false
        var seconds = secondsFromGMT()
        if seconds < 0 {
            negative = true
            seconds = seconds * -1
        }
        let hours = seconds / HourInSeconds
        let mins = seconds % HourInSeconds / MinuteInSeconds
        return (negative ? "-" : "+") + String.init(format: "%02d:%02d", hours, mins)
    }
    
    func GMTOffsetName() -> String {
        return "(GMT" + offsetString() + ") " + identifier
    }
    
    func GMTOffset() -> String {
        return "GMT" + offsetString()
    }
}
