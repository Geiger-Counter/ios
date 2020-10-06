//
//  DeviceInfo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import SwiftUI

struct DeviceInfo : View {
    
    var device : Device
    
    func show_settings() {
        
    }
    
    func show_camera() {
        
    }
    
    var body : some View {
        
        VStack {
            HStack {
                Button(action: show_settings) {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
                Spacer()
                VStack {
                    Image("Radioactivity")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                    Text("GeigerCounterApp")
                }
                Spacer()
                Button(action: show_camera){
                    Image(systemName: "camera.rotate.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            }
            .padding()
            VStack (alignment: .trailing) {
                Text(device.name)
                
            }
            .padding()
            Spacer()
            
        }
        
    }
    
}

struct DeviceInfo_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInfo(device: Device(name: "GeigerCounter"))
    }
}
