//
//  Graphing.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//



import Foundation

struct powerDataPoint: Identifiable {
    var timestamp: Double = 0.0
    var power: Double = 0.0
    
    var id: Double{timestamp}
}

struct powerDataPointSummary: Identifiable{
    var timestamp: Date = Date()
    var powerValue: Double = 0.0
    
    var id: Date { timestamp }
}

enum viewTimeFrame: String, CaseIterable, Identifiable{
    case Minute, Hour, Day, Week, All
    var id: Self{self}
}

enum graphType: String, CaseIterable, Identifiable{
    case Power, Cost
    var id: Self{self}
}

func convertDateFormatter(dateString: String) -> Date{
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//            if let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second {
//                print("Year: \(year)")
//                print("Month: \(month)")
//                print("Day: \(day)")
//                print("Time: \(hour):\(minute):\(second)")
//            }
            
            return date
            
        }
    print(">>>> INVALID TIMESTAMP STRING")
    return Date()
}

func createPowerStreamDataPoint(date: Date, power: Double) -> powerDataPointSummary{
    let newDataPoint = powerDataPointSummary(timestamp: date, powerValue: power)
    return newDataPoint
}
