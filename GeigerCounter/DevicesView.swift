//
//  DevicesView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 27.09.20.
//

import SwiftUI
import CoreBluetooth

struct Device : Hashable {
    let id = UUID()
    var name : String
    var valid : Bool
    var peripheral : CBPeripheral?
    
    init(name : String, advertisementData: [String : Any] = [:], peripheral : CBPeripheral? = nil) {
        self.name = name
        self.valid = false
        self.valid = check_device(name: name, advertisementData: advertisementData)
        self.peripheral = peripheral
    }
    
    func check_device(name : String, advertisementData: [String : Any]) -> Bool {
        if name.hasPrefix("GeigerCounter") {
            if let uuids : NSArray = advertisementData["kCBAdvDataServiceUUIDs"] as? NSArray {
                let uuid : CBUUID = uuids[0] as! CBUUID
                return uuid.uuidString == BLEUUID.DATA_SERVICE_UUID.uppercased()
            }
        }
        return false
    }
}

struct ValidationIndicator : View {
    
    var valid : Bool
    
    var body : some View {
        HStack {
            Text(valid ? "compatible" : "incompatible").foregroundColor(valid ? Color.green : Color.red).font(.system(size: 13))
            Image(systemName: valid ? "checkmark.circle" : "xmark.circle").resizable()
                .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(valid ? Color.green : Color.red)
        }
    }
    
}

struct DeviceView : View {
    
    var device : Device
    var selected : Bool
    
    var body : some View {
        HStack (spacing: 4) {
            Image(systemName: "desktopcomputer")
                .foregroundColor(device.valid ? .blue : .gray)
            Text(device.name)
                .foregroundColor(device.valid ? .blue : .gray)
            Spacer()
            ValidationIndicator(valid: device.valid)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.blue, lineWidth: selected ? 1 : 0)
        )
    }
    
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeviceView(device: Device(
                    name: "Arduino"
                ),
                selected: false
            )
        }
    }
}
