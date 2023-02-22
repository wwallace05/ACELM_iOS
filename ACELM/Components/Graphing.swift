//
//  Graphing.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

//import Foundation
struct powerDataPoint: Identifiable {
    var timestamp: Double = 0.0
    var power: Double = 0.0
    
    var id: Double{timestamp}
}

enum viewTimeFrame: String, CaseIterable, Identifiable{
    case Minute, Day, Week, Month, All
    var id: Self{self}
}

//var selectedTimeFrame = viewTimeFrame.All

