//
//  BLEHandler.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import Foundation
import CoreBluetooth

struct BLEUUID {
    static let DATA_SERVICE_UUID : String = "02ed48d7-69b1-4603-9899-a05aa175f9d6"
    static let DATA_MSV_CHAR_UUID : String = "caf31b35-b140-489f-b875-36893157d6cf"
    static let DATA_MSV_DESC_UUID : String = "3065e35b-5433-44cb-96f4-215887e225a3"
    static let DATA_CPM_CHAR_UUID : String = "a4596a0a-a378-49e4-9256-1abfe5784fbd"
    static let DATA_CPM_DEC_UUID : String = "5b4e4513-2aa3-4180-b155-c1e3a720a756"
    static let DATA_IMPULSE_CHAR_UUID : String = "91784055-76be-4865-af66-1eeb4a6fac23"
    static let DATA_IMPULSE_DEC_UUID : String = "1044196e-5e89-4a4b-89d1-8c241cbf6b8d"
}

open class BLEHandler : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject
{
    
    private var centralManager : CBCentralManager!
    @Published var peripherals : [Device] = []
    @Published var device : CBPeripheral!
    @Published var connected : Bool = false
    @Published var values : DeviceValues = get_default_values()
    @Published var impulse : Bool = false
    @Published var searching : Bool = false
    var timer = Timer()
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn) {
            start()
        }
    }
    
    func start(first : Bool = true) {
        if(first) {
            self.search()
        }
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.search), userInfo: nil, repeats: true)
    }
    
    func stop() {
        self.searching = false
        self.centralManager.stopScan()
        timer.invalidate()
    }
    
    @objc
    func search() {
        self.searching = true
        self.peripherals = []
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func disconnect() {
        centralManager.cancelPeripheralConnection(self.device)
    }
    
    public func centralManager(_ central : CBCentralManager, didDiscover peripheral : CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let device_name = peripheral.name {
            
            let detected_peripherals = peripherals.map({(device : Device) -> String in
                return device.name
            })
            
            if !detected_peripherals.contains(device_name) {
                peripherals.append(Device(name: device_name, advertisementData: advertisementData, peripheral: peripheral))
            }
            
            peripherals = peripherals.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
        }
    }
    
    func connect(device : Device) -> Void {
        self.centralManager.stopScan()
        timer.invalidate()
        self.device = device.peripheral
        self.peripherals = []
        self.device.delegate = self
        self.centralManager.connect(self.device, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.device {
            if !self.connected {
                print("Connected to " + (self.device.name ?? ""))
                self.connected = true
                self.searching = false
                peripheral.discoverServices(nil)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.device {
            if connected {
                print("Disconnected from " + (self.device.name ?? ""))
                self.connected = false
                self.peripherals = []
                self.start(first: false)
            }
        }
    }
    
    public func peripheral(_ peripheral : CBPeripheral, didDiscoverServices error : Error?) {
        if let detected_services = peripheral.services {
            _ = detected_services.map({(service : CBService) in
                peripheral.discoverCharacteristics(nil, for: service)
            })
        }
    }
    
    public func peripheral(_ peripheral : CBPeripheral, didDiscoverCharacteristicsFor service : CBService, error : Error?) {
        guard let characteristics = service.characteristics else {return}
        
        for characteristic in characteristics {
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    public func peripheral(_ peripheral : CBPeripheral, didUpdateValueFor characteristic : CBCharacteristic, error : Error?) {
        self.read_characteristic(characteristic: characteristic)
    }
    
    func read_characteristic(characteristic : CBCharacteristic) {
        guard let value = characteristic.value else { return }
        switch characteristic.uuid.uuidString {
            case BLEUUID.DATA_CPM_CHAR_UUID.uppercased():
                values.cpm = dataToInt(value)
            case BLEUUID.DATA_MSV_CHAR_UUID.uppercased():
                values.msvh = dataToFloat(value)
            case BLEUUID.DATA_IMPULSE_CHAR_UUID.uppercased():
                do_blink()
            default: return
        }
    }
    
    func dataToInt(_ data : Data?) -> Int {
      return Int(dataToValue(data))!
    }
    
    func dataToFloat(_ data : Data?) -> Float {
      return Float(dataToValue(data))!
    }
    
    func dataToBool(_ data : Data?) -> Bool {
        return Bool(dataToValue(data))!
    }
    
    func dataToValue(_ data : Data?) -> String {
      var str : String = ""
      guard let data = data else { return "" }
      if data.count < 1 {
        return ""
      }
      for i in 0...(data.count-1) {
        str.append(Character(UnicodeScalar(data[i])))
      }
      return str
    }
    
    func valueToData(str : String) -> Data {
        return str.data(using: .utf8) ?? Data([0x00])
    }
    
    func do_blink () {
        self.impulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.impulse = false
        }
    }
}
