//
//  DeviceInfo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import SwiftUI

struct DeviceInfo : View {
    
    var device : Device
    var values : DeviceValues
    
    func show_settings() {
        
    }
    
    func show_camera() {
        
    }
    
    func disconnect() {
        print("disconnect")
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
                Text("CPM: " + String(values.cpm))
                Text("mSv/h: " + String(values.msvh))
            }
            .padding()
            Spacer()
            Button(action: disconnect){
                HStack{
                    Image(systemName: "xmark.circle")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("Disconnect")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
            }
        }
        
    }
    
}

struct DeviceInfo_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInfo(device: Device(name: "GeigerCounter"), values: DeviceValues(cpm: 0, msvh: 0.0))
    }
}
