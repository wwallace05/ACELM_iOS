//
//  ContentView.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

struct ContentView: View {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @State var Outlet1 = Outlet(name: "Outlet 1", status: true)
//    @State var Outlet2 = Outlet(name: "Outlet 2", status: true)
//    @State var Outlet3 = Outlet(name: "Outlet 3", status: true)
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
//    enum viewGraphOf: String, CaseIterable, Identifiable{
//        case all, Outlet1, Outlet2, Outlet3
//        var id: Self{self}
//    }
//    
//    @State private var selectedGraph = viewGraphOf.all
    
    

    
    var body: some View {
        NavigationView {
            Form {
                PowerConsumptionView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                
                //GraphingView()
                
                OutletControl(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                
            }
            .navigationTitle("Energy Load Monitor")
            
        }
        .analyticsScreen(name: "\(ContentView.self)")
    }
}


// will not apear in final rollout
struct ContentView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "name1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "name2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "name3", status: true, powerStream: [0.0:0.0])
    static var previews: some View {
        ContentView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
            .previewInterfaceOrientation(.portrait)
    }
}