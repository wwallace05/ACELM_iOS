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
    
    @Binding var rate: Double
    
    @State var selectedTimeFrame = viewTimeFrame.All
    
    @State var selectedGraphType = graphType.Power
    
    var body: some View {
        
        let graph0 = cGraph(OutletX: $Outlet1, selectedTimeFrame: $selectedTimeFrame, selectedGraphType: $selectedGraphType, rate: $rate)
        let graph1 = aGraph(OutletX: $Outlet1, selectedTimeFrame: $selectedTimeFrame, selectedGraphType: $selectedGraphType)
        let graph2 = aGraph(OutletX: $Outlet2, selectedTimeFrame: $selectedTimeFrame, selectedGraphType: $selectedGraphType)
        let graph3 = aGraph(OutletX: $Outlet3, selectedTimeFrame: $selectedTimeFrame, selectedGraphType: $selectedGraphType)
        
        VStack(spacing: 20) {
            
            Picker("Time Frame", selection: $selectedTimeFrame){
                ForEach(viewTimeFrame.allCases) { timeView in
                    Text(timeView.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            
//            Picker("Time Frame", selection: $selectedGraphType){
//                ForEach(graphType.allCases) { graphType in
//                    Text(graphType.rawValue.capitalized)
//                }
//            }.pickerStyle(.segmented)
            
            //graph1
            graph0
            graph2
            graph3
     
        }.onAppear{
            
            
        }
    }
}

// Phasing out
struct aGraph: View {
    
    @Binding var OutletX: Outlet
    
    @Binding var selectedTimeFrame: viewTimeFrame
    
    @Binding var selectedGraphType: graphType
    
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
                    Text("Power (Watt Hour)")
                }
                
            } else {
                Text("Please update to ios 16.0+")
            }
        }
    }
}

// Phasing out
func computeDataToGraph(mainData: [powerDataPointSummary], timeFrame: viewTimeFrame) -> [powerDataPointSummary]{
    let oneMinuteAgo = Date().addingTimeInterval(-60)
    let oneDayAgo = Date().addingTimeInterval(-86400)
    let oneWeekAgo = Date().addingTimeInterval(-604800)
    let oneHourAgo = Date().addingTimeInterval(-3600)
    var dataToGraph: [powerDataPointSummary] = []
    
    if timeFrame == viewTimeFrame.Minute{
        dataToGraph = mainData.filter{$0.timestamp > oneMinuteAgo}
        if dataToGraph.count > 30{
            let removeCount = dataToGraph.count - 30
            dataToGraph.removeFirst(removeCount)
        }
    } else if timeFrame == viewTimeFrame.Day{
        dataToGraph = mainData.filter{$0.timestamp > oneDayAgo}
        if dataToGraph.count > 43200{
            let removeCount = dataToGraph.count - 43200
            dataToGraph.removeFirst(removeCount)
        }
    } else if timeFrame == viewTimeFrame.Week{
        dataToGraph = mainData.filter{$0.timestamp > oneWeekAgo}
        if dataToGraph.count > 302400{
            let removeCount = dataToGraph.count - 302400
            dataToGraph.removeFirst(removeCount)
        }
    } else if timeFrame == viewTimeFrame.Hour{
        dataToGraph = mainData.filter{$0.timestamp > oneHourAgo}
        if dataToGraph.count > 1800{
            let removeCount = dataToGraph.count - 1800
            dataToGraph.removeFirst(removeCount)
        }
    } else if timeFrame == viewTimeFrame.All{
        dataToGraph = mainData
    }
    
    return dataToGraph
}

// Returns calendar component unit to graph based on selected time frame
func computeUnitToGraph(timeFrame: viewTimeFrame) -> Calendar.Component{
    if (timeFrame == viewTimeFrame.Minute) {
        return Calendar.Component.second
    }
    if (timeFrame == viewTimeFrame.Day) {
        return Calendar.Component.hour
    }
    if (timeFrame == viewTimeFrame.Week) {
        return Calendar.Component.day
    }
    if (timeFrame == viewTimeFrame.Hour) {
        return Calendar.Component.minute
    }

    print(">>>> defaulting in computeUnitToGraph()")
    return Calendar.Component.hour
}

// Returns reference to array of data to graph based on the selected time frame
func selectDataToGraph(outlet: Outlet,timeFrame: viewTimeFrame) -> [powerDataPointSummary]{
    if (timeFrame == viewTimeFrame.Minute) {
        return outlet.minutePowerStream
    }
    if (timeFrame == viewTimeFrame.Hour) {
        return outlet.hourPowerStream
    }
    if (timeFrame == viewTimeFrame.Day) {
        return outlet.dayPowerStream
    }
    if (timeFrame == viewTimeFrame.Week) {
        return outlet.weekPowerStream
    }

    print(">>>> defaulting in selectDataToGraph()")
    return outlet.minutePowerStream
}

// Returns sum of data being graphed
func computePowerSum(currData: [powerDataPointSummary]) -> Double{
    var sum = 0.0;
    currData.forEach{ element in
        sum += element.powerValue
    }
    return sum
}

// Phasing out
struct bGraph: View {
    
    @Binding var OutletX: Outlet
    
    @Binding var selectedTimeFrame: viewTimeFrame
    
    @Binding var selectedGraphType: graphType
    
    var body: some View {
        
        VStack{
            let dataToGraph = computeDataToGraph(mainData: OutletX.datedPowerStream, timeFrame: selectedTimeFrame)
            
            HStack{
                Text("\(OutletX.name) Graph")
                Text("Cost: $80").bold()
            }
            
            if #available(iOS 16.0, *) {
                Chart(){
//
                    ForEach(dataToGraph){ powerDataPoint in
                        BarMark(
                            x: .value("time", powerDataPoint.timestamp, unit: computeUnitToGraph(timeFrame: selectedTimeFrame)),
                            y: .value("power", powerDataPoint.powerValue)
                        )
                    }
                    
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Time Stamp")
                }
                .chartYAxisLabel(position: .leading, alignment: .center) {
                    Text("Power (W)")
                }
                
            } else {
                Text("Please update to ios 16.0+")
            }
        }
    }
}

// Phasing in
struct cGraph: View {
    
    @Binding var OutletX: Outlet
    
    @Binding var selectedTimeFrame: viewTimeFrame
    
    @Binding var selectedGraphType: graphType
    
    @Binding var rate: Double
    
    var body: some View {
        
        VStack{
            let dataToGraph = selectDataToGraph(outlet: OutletX, timeFrame: selectedTimeFrame)
            let powerTotal = computePowerSum(currData: dataToGraph)
            let cost = powerTotal * rate
            
            HStack{
                Text("\(OutletX.name) Graph")
                Text("Total: \(powerTotal) kWh").bold()
            }
            
            Text("Cost: $\(cost)")
            
            if #available(iOS 16.0, *) {
                Chart(){
//
                    ForEach(dataToGraph){ powerDataPoint in
                        BarMark(
                            x: .value("Time", powerDataPoint.timestamp, unit: computeUnitToGraph(timeFrame: selectedTimeFrame)),
                            y: .value("Energy Consumed", powerDataPoint.powerValue)
                        )
                    }
                    
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text("Time Stamp")
                }
                .chartYAxisLabel(position: .leading, alignment: .center) {
                    Text("Power (kWh)")
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
    @State static var rate = 0.0
    
    static var previews: some View {
        GraphingView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3, rate: $rate)
    }
}
