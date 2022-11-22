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
    
    
//    mutating func toggleStatus(){
//        // send server command to toggle an outlet, once we recieve confirmation, then toggle
//        status = !status
//    }
//
//    func displayStatus() -> String{
//        if status{
//            return "ON"
//        }
//        return "OFF"
//    }
}
