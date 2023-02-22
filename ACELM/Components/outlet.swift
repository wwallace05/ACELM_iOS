//
//  outlet.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import Foundation
import SwiftUI
import OrderedCollections

// when integrating, each outlet should ask the server what its status is and use that
struct Outlet{
    var name: String
    var status: Bool
    var powerStream: OrderedDictionary<Double, Double>
    var graphablePowerStream: [powerDataPoint] = []
    
    mutating func appendData(Data :powerDataPoint){
        graphablePowerStream.append(Data)
    }

}
