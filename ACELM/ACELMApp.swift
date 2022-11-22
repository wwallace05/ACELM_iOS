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
    @State var Outlet1 = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State var Outlet2 = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State var Outlet3 = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    
    init(){
        FirebaseApp.configure()
    }
       
    var body: some Scene {
        WindowGroup {
            ContentView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
            //rtdb_test(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
        }
    }
}

//// when integrating, each outlet should ask the server what its status is and use that
//struct Outlet{
//    var name: String
//    var status: Bool
//    
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
//}

