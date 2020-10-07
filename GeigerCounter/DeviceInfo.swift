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
    var blinking : Bool
    
    var blink : Animation {
        Animation.linear(duration: 1)
    }
    
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
            VStack (alignment: .leading) {
                Text("Device")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.title)
                Spacer()
                    .frame(height: 15)
                HStack {
                    Image(systemName: "desktopcomputer")
                    Text(device.name)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("online")
                }
                Spacer()
                    .frame(height: 15)
                Text("Statistics")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.title)
                Spacer()
                    .frame(height: 15)
                HStack {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("CPM")
                    Image(systemName: "xmark.circle.fill")
                        .animation(blink)
                        .foregroundColor(.red)
                        .opacity(blinking ? 1 : 0)
                    Spacer()
                    Text(String(values.cpm))
                }
                
                HStack {
                    Image(systemName: "dot.radiowaves.right")
                    Text("mSv/h")
                    Spacer()
                    Text(String(format: "%.2f", values.msvh))
                }
                Spacer()
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
        DeviceInfo(device: Device(name: "GeigerCounter"), values: DeviceValues(cpm: 0, msvh: 0.0), blinking: false)
    }
}
