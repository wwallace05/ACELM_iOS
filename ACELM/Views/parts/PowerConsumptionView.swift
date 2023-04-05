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
    
    //@State private var selectedTimeFrame = viewTimeFrame.Instant
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @Binding var rate: Double
    
    // All refs for Outlet 1
    var ref1 = Database.database().reference()
    var ref2 = Database.database().reference()
    var ref3 = Database.database().reference()
    var ref4 = Database.database().reference()
    
    // All refs for Outlet 2
    var ref5 = Database.database().reference()
    var ref6 = Database.database().reference()
    var ref7 = Database.database().reference()
    var ref8 = Database.database().reference()
    
    // All refs for Outlet 3
    var ref9 = Database.database().reference()
    var ref10 = Database.database().reference()
    var ref11 = Database.database().reference()
    var ref12 = Database.database().reference()
    

    // View displaying the instant power consumption values per outlet
    var body: some View {
        Section(header: Text("Instant Power Consumption")){
            Section{
                
                Text("\(Outlet1.name): \(String(format: "%.2f", Outlet1.powerStream.elements[Outlet1.powerStream.count-1].value)) (W)")
                Text("\(Outlet2.name): \(String(format: "%.2f", Outlet2.powerStream.elements[Outlet2.powerStream.count-1].value)) (W)")
                Text("\(Outlet3.name): \(String(format: "%.2f", Outlet3.powerStream.elements[Outlet3.powerStream.count-1].value)) (W)")
                
            }
            
        }.onAppear{
            //observeData()
            observeO1Data() // FOR DEBUG
        }
        
    }
    
    // Phasing out
    // Observe Data in the DB
    func observeData(){
        self.ref1.child("test").observe(.value, with: {(snapshot) in
            
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for oSnap in oSnapShot{
                    let keyString = oSnap.key
                    let keyDouble = (keyString as NSString).doubleValue
                    let dataDouble = oSnap.value as! Double
                    if Outlet1.powerStream[keyDouble] == nil {
                        Outlet1.powerStream[keyDouble] = dataDouble
                        
                        let powerDataPoint = powerDataPoint(timestamp: keyDouble, power: dataDouble)
                        Outlet1.appendData(Data: powerDataPoint)
                        
                        //print("Timestamp: \(powerDataPoint.timestamp), Power: \(powerDataPoint.power)")
                    }
                }
            }
        })
        
        self.ref2.child("test1").observe(.value, with: {(snapshot) in
            
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for oSnap in oSnapShot{
                    let keyString = oSnap.key
                    let keyDouble = (keyString as NSString).doubleValue
                    let dataDouble = oSnap.value as! Double
                    if Outlet2.powerStream[keyDouble] == nil {
                        Outlet2.powerStream[keyDouble] = dataDouble
                        
                        let powerDataPoint = powerDataPoint(timestamp: keyDouble, power: dataDouble)
                        Outlet2.appendData(Data: powerDataPoint)
                        
                        //print("Timestamp: \(powerDataPoint.timestamp), Power: \(powerDataPoint.power)")
                    }
                }
            }
        })
        
        self.ref3.child("test2").observe(.value, with: {(snapshot) in
            
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for oSnap in oSnapShot{
                    let keyString = oSnap.key
                    let keyDouble = (keyString as NSString).doubleValue
                    let dataDouble = oSnap.value as! Double
                    if Outlet3.powerStream[keyDouble] == nil {
                        Outlet3.powerStream[keyDouble] = dataDouble
                        
                        let powerDataPoint = powerDataPoint(timestamp: keyDouble, power: dataDouble)
                        Outlet3.appendData(Data: powerDataPoint)
                        
                        //print("Timestamp: \(powerDataPoint.timestamp), Power: \(powerDataPoint.power)")
                    }
                }
            }
        })
        
        var counter = 0
        // testing new timestamp formatting
        self.ref4.child("GraphTest").observe(.childAdded, with: {(snapshot) in
            
            
          
            let keyString = snapshot.key
            let dataDouble = snapshot.value as! Double

            let date = convertDateFormatter(dateString: keyString)
            let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)
            if !Outlet1.datedPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                Outlet1.appendData(Data: dataPoint)
                print(">>>> Added new data point \(counter)")
                counter += 1
            } else {
                print(">>>> Data Point already Exists ")
            }
        })
    }
    
    // Observe All Outlets data
    // This implementation deletes the entire array and remakes it when data is modified in the DB
    func observeAllData(){
        // Observe ALL Outlet 1 data
        
            // Observe Outlet 1 Minute Data
        var counter = 0
        self.ref1.child("O1Example/minute").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.minutePowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.minutePowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.minutePowerStream.append(dataPoint)
                        print(">>>> O1_m Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Hour Data
        counter = 0
        self.ref2.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.hourPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.hourPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.hourPowerStream.append(dataPoint)
                        print(">>>> O1_h Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Day Data
        counter = 0
        self.ref3.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.dayPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.dayPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.dayPowerStream.append(dataPoint)
                        print(">>>> O1_d Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Week Data
        counter = 0
        self.ref4.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.weekPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.weekPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.weekPowerStream.append(dataPoint)
                        print(">>>> O1_w Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
        
        // Observe ALL Outlet 2 data
        
            // Observe Outlet 2 Minute Data
        counter = 0
        self.ref5.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet2.minutePowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet2.minutePowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet2.minutePowerStream.append(dataPoint)
                        print(">>>> O2_m Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Hour Data
        counter = 0
        self.ref6.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet2.hourPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet2.hourPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet2.hourPowerStream.append(dataPoint)
                        print(">>>> O2_h Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Day Data
        counter = 0
        self.ref7.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.dayPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.dayPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.dayPowerStream.append(dataPoint)
                        print("++++ O1_d Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Week Data
        counter = 0
        self.ref8.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet2.weekPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet2.weekPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet2.weekPowerStream.append(dataPoint)
                        print("++++ O2_w Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
        
        // Observe ALL Outlet 3 data
        
            // Observe Outlet 3 Minute Data
        counter = 0
        self.ref9.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet3.minutePowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet3.minutePowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet3.minutePowerStream.append(dataPoint)
                        print(">>>> O3_m Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Hour Data
        counter = 0
        self.ref10.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet3.hourPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet3.hourPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet3.hourPowerStream.append(dataPoint)
                        print(">>>> O3_h Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Day Data
        counter = 0
        self.ref11.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet3.dayPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet3.dayPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet3.dayPowerStream.append(dataPoint)
                        print("++++ O3_d Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 2 Week Data
        counter = 0
        self.ref12.child("xxxxxx").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet3.weekPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet3.weekPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet3.weekPowerStream.append(dataPoint)
                        print("++++ O3_w Added new data point \(counter)")
                        counter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
    }
    
    func observeO1Data(){
        // Observe ALL Outlet 1 data
        print(">>>> Attempting to observe O1 data")
            // Observe Outlet 1 Minute Data
        var counter = 0
        var totalCounter = 0
        let startTime = DispatchTime.now()
        self.ref1.child("O1Example/minute").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.minutePowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.minutePowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.minutePowerStream.append(dataPoint)
                        print(">>>> O1_m Added new data point \(counter)")
                        counter += 1
                        totalCounter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Hour Data
        counter = 0
        self.ref2.child("O1Example/hour").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.hourPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.hourPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.hourPowerStream.append(dataPoint)
                        print(">>>> O1_h Added new data point \(counter)")
                        counter += 1
                        totalCounter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Day Data
        counter = 0
        self.ref3.child("O1Example/day").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.dayPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.dayPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.dayPowerStream.append(dataPoint)
                        print(">>>> O1_d Added new data point \(counter)")
                        counter += 1
                        totalCounter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
            }
        })
        
            // Observe Outlet 1 Week Data
        counter = 0
        self.ref4.child("O1Example/week").observe(.value, with: {(snapshot) in
            if let oSnapShot = snapshot.children.allObjects as? [DataSnapshot]{
                Outlet1.weekPowerStream.removeAll()
                for oSnap in oSnapShot{
                    let keyString = oSnap.key                   // Timestamp
                    let dataDouble = oSnap.value as! Double     // Energy Value
                    
                    let date = convertDateFormatter(dateString: keyString)  // Convert timestamp to Date object
                    let dataPoint = createPowerStreamDataPoint(date: date, power: dataDouble)   // Create dataPoint Struct
                    if !Outlet1.weekPowerStream.contains(where: {$0.timestamp == dataPoint.timestamp}){
                        Outlet1.weekPowerStream.append(dataPoint)
                        print(">>>> O1_w Added new data point \(counter)")
                        counter += 1
                        totalCounter += 1
                    } else {
                        print(">>>> Data Point already Exists ")
                    }
                }
                print(">>>> Total # of data points: [\(totalCounter)]")
                let endTime = DispatchTime.now()
                var timeElapsed = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
                //print(">>>> Time elapsed: [\(timeElapsed)] s")
                timeElapsed = timeElapsed * 1000
                print(">>>> Time elapsed: [\(timeElapsed)] ms")
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
