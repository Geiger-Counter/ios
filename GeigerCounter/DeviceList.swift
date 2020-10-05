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
    @State private var selected_device : String = ""
    
    init(devices : [Device]) {
        self.devices = devices
    }
    
    func connect() {
        print("Connect")
    }
    
    func select(device : Device) -> () -> () {
        return {
            selected_device = device.name
        }
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
            List(devices, id: \.name) { device in
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

struct DeviceList_Previews: PreviewProvider {
    static var previews: some View {
        DeviceList(devices: [
            Device(name: "Arduino", valid: false),
            Device(name: "GeigerCounter", valid: true)
        ])
    }
}
