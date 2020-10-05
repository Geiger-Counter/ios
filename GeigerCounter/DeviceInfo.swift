//
//  DeviceInfo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import Foundation
import SwiftUI

struct DeviceInfo : View {
    
    var device : Device
    
    var body : some View {
        Text(device.name)
    }
    
}

struct DeviceInfo_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
