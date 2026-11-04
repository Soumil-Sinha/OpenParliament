//
//  Date+Formatting.swift
//  OpenParliament
//

import Foundation

extension Date {

    /// "19 Jul 2023"
    var mediumDay: String {
        formatted(.dateTime.day().month(.abbreviated).year())
    }

    /// "Jul 2023"
    var monthYear: String {
        formatted(.dateTime.month(.abbreviated).year())
    }
}
