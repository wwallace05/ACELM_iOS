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
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var rate: Double
    
    var body: some View {
        
        
        
        TabView{
            MainView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, rate: $rate)
                .tabItem {
                    Image(systemName: "poweroutlet.strip.fill")
                    Text("Main")
                }
            
            GraphingView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Graph")
                }
            
            SettingsViewWrap(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}



struct MainView: View {
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var rate: Double
    var body: some View {
        
        NavigationView {
            Form {
                PowerConsumptionView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, rate: $rate)
                
                OutletControl(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                
                PriceManagerView(rate: $rate)
                
            }
            .navigationTitle("Energy Load Monitor")
            
        }
        .analyticsScreen(name: "\(ContentView.self)")
        
    }
}


struct SettingsViewWrap: View {
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    var body: some View {
        NavigationView{
            Form{
                SettingsView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
            }.navigationTitle("Settings")
        }
    }
}


// will not apear in final rollout
struct ContentView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    @State static var rate = 0.0
    
    static var previews: some View {
        ContentView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3, rate: $rate)
            .previewInterfaceOrientation(.portrait)
    }
}
