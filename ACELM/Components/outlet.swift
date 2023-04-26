//
//  outlet.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import Foundation
import SwiftUI
import OrderedCollections

// Outlet structure. One for each physical outlet
struct Outlet{
    var name: String
    var status: Bool
    var latestPowerValue: Double
    
    // need to phase out
    var powerStream: OrderedDictionary<Double, Double>
    var graphablePowerStream: [powerDataPoint] = []
    
    // need to use
    var datedPowerStream: [powerDataPointSummary] = []
    var minutePowerStream: [powerDataPointSummary] = []
    var hourPowerStream: [powerDataPointSummary] = []
    var dayPowerStream: [powerDataPointSummary] = []
    var weekPowerStream: [powerDataPointSummary] = []
    
    mutating func getInstantPower() -> Double {
        return minutePowerStream.last?.powerValue ?? 1.0
    }
    
    // UNUSED
    mutating func appendData(Data :powerDataPoint){
        graphablePowerStream.append(Data)
    }

    // UNUSED
    mutating func appendData(Data :powerDataPointSummary){
        datedPowerStream.append(Data)
    }
}
