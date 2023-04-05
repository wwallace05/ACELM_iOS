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
    
    @Binding var Outlet1_name: String
    @Binding var Outlet2_name: String
    @Binding var Outlet3_name: String
    
    @State var showingAlert = false
    
    
    // Settings view allows users to edit the names of the outlets
    // These names are saved in local storage
    var body: some View {
        Section(header: Text("Outlet Names")) {
            TextField("Outlet 1", text: $Outlet1_name)
                //.padding()
            TextField("Outlet 2", text: $Outlet2_name)
                //.padding()
            TextField("Outlet 3", text: $Outlet3_name)
                //.padding()
            Button("Save Changes") {
                self.showingAlert = true
                print(">>>>  attempting to save")
                
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Save Changes"), message: Text("Are you sure you want to save the changes?"), primaryButton: .default(Text("Save"), action: {
                    updateNames()
                }), secondaryButton: .cancel())
            }
        }//.alert(isPresented: $showingAlert) {
//            Alert(title: Text("Save Changes"), message: Text("Are you sure you want to save the changes?"), primaryButton: .default(Text("Save"), action: {
//                // Save the changes here
//                print(">>>>  attempting to save")
//                updateNames()
//            }), secondaryButton: .cancel())
//        }
        
//        Section(header: Text("Location Services")) {
//            Text("")
//
////            Button("Update to current location") {
////                self.showingAlert = true
////            }
//        }

    }
    
    // Saves the new names input by user to local storage
    func updateNames(){
        Outlet1.name = "\(Outlet1_name)"
        Outlet2.name = "\(Outlet2_name)"
        Outlet3.name = "\(Outlet3_name)"
        
        print(">>>> Updated Names")
        print(">>>> O1 [\(Outlet1.name)]")
        print(">>>> O2 [\(Outlet2.name)]")
        print(">>>> O3 [\(Outlet3.name)]")
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "Outlet 1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "Outlet 2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "Outlet 3", status: true, powerStream: [0.0:0.0])
    
    @State static var Outlet1_name = "Outlet 1"
    @State static var Outlet2_name = "Outlet 2"
    @State static var Outlet3_name = "Outlet 3"
    
    static var previews: some View {
        SettingsView(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3, Outlet1_name: $Outlet1_name, Outlet2_name: $Outlet2_name, Outlet3_name: $Outlet3_name)
    }
}
