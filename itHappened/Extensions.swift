//
//  Extensions.swift
//  itHappened
//
//  Created by Dave Carlton on 10/25/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import Foundation

extension NSDate {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: self as Date)
    }
}

extension String {
    var asNSDate: NSDate {
        let styler = DateFormatter()
        styler.dateFormat = "M/d/yyyy h:mm:ss a"
        return styler.date(from: self) as NSDate? ?? NSDate()
    }
}
