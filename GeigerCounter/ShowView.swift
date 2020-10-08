//
//  DeviceInfo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import SwiftUI

struct ShowView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    var blink : Animation {
        Animation.linear(duration: 1)
    }
    
    func show_settings() {
        state.change_state(view: ViewState.SETTINGS)
    }
    
    func show_camera() {
        state.change_state(view: ViewState.AI)
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
                    Text(state.device!.name)
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
                        .opacity(ble_handler.impulse ? 1 : 0)
                    Spacer()
                    Text(String(ble_handler.values.cpm))
                }
                
                HStack {
                    Image(systemName: "dot.radiowaves.right")
                    Text("mSv/h")
                    Spacer()
                    Text(String(format: "%.2f", ble_handler.values.msvh))
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
