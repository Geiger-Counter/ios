//
//  Characteristic.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 09.10.20.
//

import Foundation
import CoreBluetooth

struct Characteristic<T> {
    
    var UUID : String
    var DESC : String
    var handler : CBCharacteristic? = nil
    
    
    
}
