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

struct DeviceSettings {
    var ssid : String
    var password : String
    var endpoint : String
    var username : String
    var token : String
}

struct DeviceValues {
    var cpm : Int
    var msvh : Float
    var settings : DeviceSettings
}

func get_default_values() -> DeviceValues {
    return DeviceValues(cpm: 0, msvh: 0.0, settings: DeviceSettings(
                            ssid: "",
                            password: "",
                            endpoint: "",
                            username: "",
                            token: ""
    ))
}
