//
//  Device.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 07.10.20.
//

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

struct DeviceValues {
    var cpm : Int
    var msvh : Float
}
