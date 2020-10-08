//
//  SearchView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 27.09.20.
//

import SwiftUI
import CoreBluetooth

struct SearchView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @State private var selected_device : String = ""
    @ObservedObject var state : MainState
    
    func connect() {
        let device : Device = get_selected_device()
        ble_handler.connect(device: device)
        state.change_state(view: ViewState.SHOW, device : device)
    }
    
    func select(device : Device) -> () -> () {
        return {
            selected_device = device.name
        }
    }
    
    func get_selected_device() -> Device {
        let device = ble_handler.peripherals.filter {(peripheral : Device) -> Bool in
            return self.selected_device == peripheral.name
        }
        return device[0]
    }
    
    var selected : Bool {
        return selected_device != ""
    }
    
    var button_color : Color {
        return selected ? Color.green : Color.gray
    }
    
    var body : some View {
        VStack {
                RotatingLogo(duration: 8)
                Text("Available Devices")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.title)
                List(ble_handler.peripherals, id: \.name) { device in
                    Button(action: self.select(device: device)){
                        DeviceView(
                            device: device,
                            selected: device.name == selected_device
                        )
                    }
                    .disabled(!device.valid)
                    .padding([.leading, .trailing], 0)
                }
                Button(action: connect){
                    HStack{
                        Image(systemName: "link")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Connect")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(button_color)
                }
                .disabled(!selected)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    
}
