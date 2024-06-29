//
//  Helper.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 20.06.2024.
//

import Foundation

enum DateConverterHelper {
    static var dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    static var dateFormatterShort = {
        let dateFormatterShort = DateFormatter()
        dateFormatterShort.dateFormat = "dd MMMM"
        return dateFormatterShort
    }()
    
    static func UTCToLocal(date: String) -> Date? {
        guard let utcDate = dateFormatter.date(from: date) else {
            return nil
        }
        
        let timeZoneOffset = TimeZone.current.secondsFromGMT(for: utcDate)
        return Calendar.current.date(byAdding: .second, value: timeZoneOffset, to: utcDate)
    }
    
    static func localToUTC(date: Date) -> String {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
}
