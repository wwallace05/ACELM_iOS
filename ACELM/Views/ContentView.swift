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
    
//    @Binding var Outlet1: Outlet
//    @Binding var Outlet2: Outlet
//    @Binding var Outlet3: Outlet
//
    
    @Binding var Outlet1_name: String
    @Binding var Outlet2_name: String
    @Binding var Outlet3_name: String
    
    @Binding var SavedRate: Double
    @Binding var SavedProvider: String
    
    @State var Outlet1 = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State var Outlet2 = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State var Outlet3 = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    
    //@State var rate = 0.0
    @Binding var rate: Double
    @Binding var provider: String
    
    
    
    var body: some View {
               
        TabView{
            HomeView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, rate: self.$rate, provider: self.$provider, SavedRate: self.$SavedRate, SavedProvider: self.$SavedProvider)
                .tabItem {
                    Image(systemName: "poweroutlet.strip.fill")
                    Text("Main")
                }
            
            GraphingView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Graph")
                }
            
            SettingsViewWrap(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onAppear{
            updateNames()
        }
    }
    
    func updateNames(){
        Outlet1.name = "\(Outlet1_name)"
        Outlet2.name = "\(Outlet2_name)"
        Outlet3.name = "\(Outlet3_name)"
    }
}



struct HomeView: View {
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var rate: Double
    @Binding var provider: String
    
    @Binding var SavedRate: Double
    @Binding var SavedProvider: String

    var body: some View {
        
        NavigationView {
            Form {
                PriceManagerView(rate: self.$rate, provider: self.$provider, SavedRate: self.$SavedRate, SavedProvider: $SavedProvider)
                
                PowerConsumptionView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, rate: self.$rate)
                
                OutletControl(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3)
                
                
                
            }
            .navigationTitle("Energy Load Monitor")
            
        }
        //.analyticsScreen(name: "\(ContentView.self)")
        
    }
}


struct SettingsViewWrap: View {
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var Outlet1_name: String
    @Binding var Outlet2_name: String
    @Binding var Outlet3_name: String
    
    var body: some View {
        NavigationView{
            Form{
                SettingsView(Outlet1: self.$Outlet1, Outlet2: self.$Outlet2, Outlet3: self.$Outlet3, Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name)
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
    @State static var provider = ""
    
    @State static var SavedRate = 0.0
    @State static var SavedProvider = ""
    
    @State static var Outlet1_name = "Outlet 1"
    @State static var Outlet2_name = "Outlet 2"
    @State static var Outlet3_name = "Outlet 3"
    
    static var previews: some View {

        ContentView(Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name, SavedRate: $SavedRate, SavedProvider: $SavedProvider, rate: $rate, provider: $provider)
//        ContentView(Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name, SavedRate: $SavedRate, SavedProvider: $SavedProvider)
            .previewInterfaceOrientation(.portrait)
    }
}
