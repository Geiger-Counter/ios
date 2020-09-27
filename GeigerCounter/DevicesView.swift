//
//  DevicesView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 27.09.20.
//

import Foundation
import SwiftUI

struct Device {
    var name : String
    var valid : Bool
}

struct ValidationIndicator : View {
    
    var valid : Bool
    
    var body : some View {
        HStack {
            Text(valid ? "compatible" : "incompatible").foregroundColor(valid ? Color.green : Color.red).font(.system(size: 13))
            Image(valid ? "CheckIcon" : "CrossIcon").resizable().frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
    
}

struct DeviceView : View {
    
    var device : Device
    
    var body : some View {
        HStack {
            Text(device.name)
            ValidationIndicator(valid: device.valid).frame(width: 150, height: 50, alignment: .trailing)
        }
    }
    
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeviceView(device: Device(
                    name: "Arduino",
                    valid: false
                )
            )
        }
    }
}
