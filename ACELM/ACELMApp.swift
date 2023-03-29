//
//  ACELMApp.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import SwiftUI
import Firebase
import OrderedCollections

//import FirebaseCore
//import FirebaseDatabase
//import FirebaseDatabaseSwift
//
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//    FirebaseApp.configure()
//    return true
//  }
//
//}


@main
struct ACELM: App {
    
    @AppStorage("Outlet1_name") var Outlet1_name = "Outlet 1"
    @AppStorage("Outlet2_name") var Outlet2_name = "Outlet 2"
    @AppStorage("Outlet3_name") var Outlet3_name = "Outlet 3"
    
    @AppStorage("SavedProvider") var SavedProvider = "None"
    @AppStorage("SavedRate") var SavedRate = 0.0
    
//    @State var Outlet1 = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
//    @State var Outlet2 = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
//    @State var Outlet3 = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
//    
    @State var rate = 0.0
    @State var provider = ""
    
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
    }
       
    var body: some Scene {
        WindowGroup {
            //ContentView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3, rate: $rate)
            ContentView(Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name, SavedRate: $SavedRate, SavedProvider: $SavedProvider, rate: $rate, provider: $provider)
            //rtdb_test(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
            //location_test()
            //JSON_test()
            //PriceManagerView()
        }
    }
}
