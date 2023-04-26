//
//  user.swift
//  ACELM
//
//  Created by Will Wallace on 11/22/22.
//

// UNUSED

import Foundation

struct auser{
    var coordinates: (lat: Double, lon: Double)
}

// Time frames for graphing
enum rateType: String, CaseIterable, Identifiable{
    case Residential, Commercial, Industrial
    var id: Self{self}
}
