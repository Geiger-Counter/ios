//
//  DeviceList.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 27.09.20.
//

import Foundation
import SwiftUI

struct DeviceList : View {
    
    var devices : [Device]
    
    var body : some View {
        List(devices, id: \.name) { device in
            DeviceView(device: device)
        }
    }
    
}

struct DeviceList_Previews: PreviewProvider {
    static var previews: some View {
        DeviceList(devices: [
            Device(name: "Arduino", valid: false),
            Device(name: "GeigerCounter", valid: true)
        ])
    }
}
