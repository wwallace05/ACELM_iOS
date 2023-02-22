//
//  GraphingView.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import SwiftUI
import Charts

struct GraphingView: View {
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
//    enum viewTimeFrame: String, CaseIterable, Identifiable{
//        case Minute, Day, Week, Month, All
//        var id: Self{self}
//    }
    
    @State var selectedTimeFrame = viewTimeFrame.All
    
    var body: some View {
        
        let graph1 = aGraph(OutletX: $Outlet1, selectedTimeFrame: $selectedTimeFrame)
        let graph2 = aGraph(OutletX: $Outlet2, selectedTimeFrame: $selectedTimeFrame)
        let graph3 = aGraph(OutletX: $Outlet3, selectedTimeFrame: $selectedTimeFrame)
        
        VStack(spacing: 20) {
            
            Picker("Time Frame", selection: $selectedTimeFrame){
                ForEach(viewTimeFrame.allCases) { timeView in
                    Text(timeView.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            
            graph1
            graph2
            graph3
     
        }.onAppear{
            
            
        }
    }
}

struct aGraph: View {
    
    @Binding var OutletX: Outlet
    
    @Binding var selectedTimeFrame: viewTimeFrame
    
    var body: some View {
        
        VStack{
            Text("\(OutletX.name) Graph")
            if #available(iOS 16.0, *) {
                Chart(){
                    if (selectedTimeFrame == viewTimeFrame.All){
                        ForEach(OutletX.graphablePowerStream){ powerDataPoint in
                            BarMark(
                                x: .value("time", powerDataPoint.timestamp),
                                y: .value("power", powerDataPoint.power)
                            )
                        }
                    }
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Time Stamp")
                }
                .chartYAxisLabel(position: .leading, alignment: .center) {
                    Text("Power (kW)")
                }
                
            } else {
                Text("Please update to ios 16.0+")
            }
        }
    }
}

struct GraphingView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    
    static var previews: some View {
        GraphingView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
    }
}
