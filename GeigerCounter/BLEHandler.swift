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
  static let SETTINGS_SERVICE_UUID : String = "647ac72a-0b70-430b-914b-f0436652e356"
  static let DATA_MSV_CHAR_UUID : String = "caf31b35-b140-489f-b875-36893157d6cf"
  static let DATA_MSV_DESC_UUID : String = "3065e35b-5433-44cb-96f4-215887e225a3"
  static let DATA_CPM_CHAR_UUID : String = "a4596a0a-a378-49e4-9256-1abfe5784fbd"
  static let DATA_CPM_DEC_UUID : String = "5b4e4513-2aa3-4180-b155-c1e3a720a756"
  static let DATA_IMPULSE_CHAR_UUID : String = "91784055-76be-4865-af66-1eeb4a6fac23"
  static let DATA_IMPULSE_DEC_UUID : String = "1044196e-5e89-4a4b-89d1-8c241cbf6b8d"
  static let SETTINGS_SSID_CHAR_UUID : String = "8526a1b5-329c-4e09-8892-a362c4f7d174"
  static let SETTINGS_SSID_DEC_UUID : String = "d2b60679-7a12-4897-acf6-91975cf39721"
  static let SETTINGS_PASSWORD_CHAR_UUID : String = "61e5e86c-1812-4025-af0d-6575b3eebd44"
  static let SETTINGS_PASSWORD_DEC_UUID : String = "1f86e908-3b3f-4c9f-9cb4-70a7cd282c9e"
  static let SETTINGS_ENDPOINT_CHAR_UUID : String = "1f732276-49c6-4637-b12d-d3bff3249dcc"
  static let SETTINGS_ENDPOINT_DEC_UUID : String = "a375f2fa-d3f2-4231-913b-dd0c8960efe1"
  static let SETTINGS_USERNAME_CHAR_UUID : String = "27929fb9-4b99-4542-a052-d7fcea739e56"
  static let SETTINGS_USERNAME_DEC_UUID : String = "83b6563d-ea8f-4018-b9ba-a12c30137b8f"
  static let SETTINGS_TOKEN_CHAR_UUID : String = "15dfd818-f717-45bc-9e96-b1cdacd873ee"
  static let SETTINGS_TOKEN_DEC_UUID : String = "77a5a470-632a-4e81-87cd-e356b5844351"
}

open class BLEHandler : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject
{
    
    private var centralManager : CBCentralManager!
    @Published var peripherals : [Device] = []
    @Published var device : CBPeripheral!
    @Published var connected : Bool = false
    @Published var values : DeviceValues = get_default_values()
    @Published var impulse : Bool = false
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        start()
    }
    
    func start() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stop() {
        self.centralManager.stopScan()
    }
    
    public func centralManager(_ central : CBCentralManager, didDiscover peripheral : CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let device_name = peripheral.name {
            
            let detected_peripherals = peripherals.map({(device : Device) -> String in
                return device.name
            })
            
            if !detected_peripherals.contains(device_name) {
                peripherals.append(Device(name: device_name, advertisementData: advertisementData, peripheral: peripheral))
            }
        }
    }
    
    func connect(device : Device) -> Void {
        self.stop()
        self.device = device.peripheral
        self.device.delegate = self
        self.centralManager.connect(self.device, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.device {
            if !self.connected {
                print("Connected to " + (self.device.name ?? ""))
                self.connected = true
                peripheral.discoverServices(nil)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.device {
            if connected {
                print("Disconnected from " + (self.device.name ?? ""))
                self.connected = false
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
                print("Impulse")
                do_blink()
            case BLEUUID.SETTINGS_SSID_CHAR_UUID.uppercased():
                values.settings.ssid = dataToValue(value)
            case BLEUUID.SETTINGS_PASSWORD_CHAR_UUID.uppercased():
                values.settings.password = dataToValue(value)
            case BLEUUID.SETTINGS_ENDPOINT_CHAR_UUID.uppercased():
                values.settings.endpoint = dataToValue(value)
            case BLEUUID.SETTINGS_USERNAME_CHAR_UUID.uppercased():
                values.settings.username = dataToValue(value)
            case BLEUUID.SETTINGS_TOKEN_CHAR_UUID.uppercased():
                values.settings.username = dataToValue(value)
            default: return
        }
    }
    
    func dataToInt(_ data : Data?) -> Int {
      return Int(dataToValue(data))!
    }
    
    func dataToFloat(_ data : Data?) -> Float {
      return Float(dataToValue(data))!
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
    
    func do_blink () {
        self.impulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.impulse = false
        }
    }
}
