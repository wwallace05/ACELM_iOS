//
//  rtdb_test.swift
//  ACELM
//
//  Created by Will Wallace on 11/18/22.
//

import SwiftUI
import Firebase
import OrderedCollections

struct rtdb_test: View {
    
    @State var outletData = [String]()
    @State var objData: OrderedDictionary<Double, Double> = [:]
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    var ref1 = Database.database().reference()
    
//    init(){
//        observeData()
//    }

    
    var body: some View {
        
        NavigationView{
            List(){
                Section{
                    Text("Welcome!")
                    Button("Click Me", action: observeData)
                }
                Section{
//                    ForEach(outletData, id: \.self){ value in
//                        Text("\(value)")
//
//                    }
                    Text("\(Outlet1.powerStream.elements[Outlet1.powerStream.count-1].key) : \(Outlet1.powerStream.elements[Outlet1.powerStream.count-1].value)")

//                    ForEach(Outlet1.powerStream.sorted(by: >), id: \.key) { key, value in
//                        Text("\(key) : \(value)")
//                    }
                }
            }
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
                    //self.outletData.append(keyString + ": " + dataString)
                    //self.outletData.insert(keyString + ": \(dataDouble)", at: 0)
                    Outlet1.powerStream[keyDouble] = dataDouble
                    
//                    let keyString = oSnap.key
//                    let dataString = oSnap.value(forKeyPath: oSnap.key) as! String
//                    self.objData.append(keyString )
    
                }
            }
        })
        //Outlet1.powerStream = Outlet1.powerStream.reversed()
    }
    
    
    
}


struct rtdb_test_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "name1", status: true, latestPowerValue: 0.0, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "name2", status: true, latestPowerValue: 0.0, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "name3", status: true, latestPowerValue: 0.0, powerStream: [0.0:0.0])
    
    static var previews: some View {
        rtdb_test(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
    }
}
