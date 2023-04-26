//
//  Graphing.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//



import Foundation

// Phasing out
struct powerDataPoint: Identifiable {
    var timestamp: Double = 0.0
    var power: Double = 0.0
    
    var id: Double{timestamp}
}

// Used data structure for graphing
struct powerDataPointSummary: Identifiable{
    var timestamp: Date = Date()
    var powerValue: Double = 0.0
    
    var id: Date { timestamp }
}

// Time frames for graphing
enum viewTimeFrame: String, CaseIterable, Identifiable{
    case Minute, Hour, Day, Week
    var id: Self{self}
}

// Phasing out
enum graphType: String, CaseIterable, Identifiable{
    case Power, Cost
    var id: Self{self}
}

// Converts timestamp pulled from DB to swift Date object
func convertDateFormatter(dateString: String) -> Date{
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
    
    print(">>>> INVALID TIMESTAMP STRING")
    return Date()
}

// Using Timestamp and power value from DB, creates a powerStreamDataPointSummary Object to be used for graphing
func createPowerStreamDataPoint(date: Date, power: Double) -> powerDataPointSummary{
    let newDataPoint = powerDataPointSummary(timestamp: date, powerValue: power)
    return newDataPoint
}
