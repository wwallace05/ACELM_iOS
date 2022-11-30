//
//  PowerConsumptionView.swift
//  ACELM
//
//  Created by Will Wallace on 11/21/22.
//

import SwiftUI
import Firebase

struct PowerConsumptionView: View {
    enum viewTimeFrame: String, CaseIterable, Identifiable{
        case Instant, One, Two, Six
        var id: Self{self}
    }
    
    @State private var selectedTimeFrame = viewTimeFrame.Instant
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var rate: Double
    
    var ref1 = Database.database().reference()
    
    var body: some View {
        Section(header: Text("Power Consumption View")){
            Section{
                
                Text("\(Outlet1.name): \(String(format: "%.2f", Outlet1.powerStream.elements[Outlet1.powerStream.count-1].value)) (W)           \t\t~$\(String(format: "%.2f", Outlet1.powerStream.elements[Outlet1.powerStream.count-1].value * rate))")
                Text("\(Outlet2.name): 0 (W) \t\t\t\t ~$")
                Text("\(Outlet3.name): 0 (W) \t\t\t\t ~$")
                
            }
            
            Section(){
                
                Text("Time Frame (Hours)")
                Picker("Time Frame", selection: $selectedTimeFrame){
                    ForEach(viewTimeFrame.allCases) { timeView in
                        Text(timeView.rawValue.capitalized)
                    }
                }
            }.pickerStyle(.segmented)
        }.onAppear{
            observeData()
        }
    }
    
    func observeData(){
        self.ref1.child("test").observe(.value, with: {(snapshot) in
            
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for oSnap in oSnapShot{
                    let keyString = oSnap.key
                    let keyDouble = (keyString as NSString).doubleValue
                    let dataDouble = oSnap.value as! Double
                    Outlet1.powerStream[keyDouble] = dataDouble
                }
            }
        })
    }
}

struct PowerConsumptionView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    @State static var rate = 0.0
    
    static var previews: some View {
        
        PowerConsumptionView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3, rate: $rate)
    }
}
