//
//  OutletControl.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import SwiftUI
import Firebase

struct OutletControl: View {
    @Binding var Outlet1: Outlet
    @Binding var Outlet2: Outlet
    @Binding var Outlet3: Outlet
    
    
    
    var body: some View {
        Section(header: Text("Oulet Control")){
            Toggle("Outlet 1", isOn: $Outlet1.status).onChange(of: Outlet1.status){ value in
                if (!value){
                    var _: Void = Database.database().reference().child("sensor1status").setValue(0)
                }
                
                if (value){
                    var _: Void = Database.database().reference().child("sensor1status").setValue(1)
                }
            }
            
            Toggle("Outlet 2", isOn: $Outlet2.status).onChange(of: Outlet2.status){ value in
                if (!value){
                    var _: Void = Database.database().reference().child("sensor2status").setValue(0)
                }
                
                if (value){
                    var _: Void = Database.database().reference().child("sensor2status").setValue(1)
                }
            }
            
            Toggle("Outlet 3", isOn: $Outlet3.status).onChange(of: Outlet3.status){ value in
                if (!value){
                    var _: Void = Database.database().reference().child("sensor3status").setValue(0)
                }
                
                if (value){
                    var _: Void = Database.database().reference().child("sensor3status").setValue(1)
                }
            }
            
            
        }
    }
}

struct OutletControl_Previews: PreviewProvider {
    @State static var Outlet1: Outlet = Outlet(name: "name1", status: true, powerStream: [0.0:0.0])
    @State static var Outlet2: Outlet = Outlet(name: "name2", status: true, powerStream: [0.0:0.0])
    @State static var Outlet3: Outlet = Outlet(name: "name3", status: true, powerStream: [0.0:0.0])
    
    
    static var previews: some View {
        OutletControl(Outlet1: $Outlet1, Outlet2: $Outlet2, Outlet3: $Outlet3)
    }
}
