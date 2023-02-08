//
//  SettingsView.swift
//  ACELM
//
//  Created by Will Wallace on 1/18/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    @State var showingAlert = false
    
    //@Binding var coordinates: (lat: Double, lon: Double)
    
    var body: some View {
        Section(header: Text("Outlet Names")) {
            TextField("Outlet 1", text: $Outlet1.name)
                //.padding()
            TextField("Outlet 2", text: $Outlet2.name)
                //.padding()
            TextField("Outlet 3", text: $Outlet3.name)
                //.padding()
            Button("Save Changes") {
                self.showingAlert = true
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Save Changes"), message: Text("Are you sure you want to save the changes?"), primaryButton: .default(Text("Save"), action: {
                // Save the changes here
            }), secondaryButton: .cancel())
        }
        
        Section(header: Text("Location Services")) {
            Text("")
            
            Button("Update to current location") {
                self.showingAlert = true
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Save Changes"), message: Text("Are you sure you want to save the changes?"), primaryButton: .default(Text("Save"), action: {
                // Save the changes here
                
                // fetch coordinates again and make API call
                
            }), secondaryButton: .cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    
    static var previews: some View {
        SettingsView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
    }
}
