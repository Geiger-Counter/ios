//
//  DeviceInfo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import SwiftUI

struct NavigationIndicator : UIViewControllerRepresentable {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    typealias UIViewControllerType = ARViewController
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<NavigationIndicator>) {}
    
}

struct ShowView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    var blink : Animation {
        Animation.linear(duration: 1)
    }
    
    var color : Color {
        let msvh = ble_handler.values.msvh
        if(msvh < 11.0) {
            return .green
        } else if (msvh >= 11.0 && msvh < 57) {
            return .yellow
        } else {
            return .red
        }
    }
    
    func show_info() {
        state.change_state(view: ViewState.INFO)
    }
    
    func show_camera() {
        state.change_state(view: ViewState.AR)
    }
    
    func disconnect() {
        ble_handler.disconnect()
    }
    
    var body : some View {
        
        VStack {
            HStack {
                Button(action: show_info) {
                    Image(systemName: "info.circle.fill")
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
                Group {
                    Text("Device")
                        .fontWeight(.bold)
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
                }
                Spacer()
                    .frame(height: 15)
                Group {
                    Text("Statistics")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.title)
                    Spacer()
                        .frame(height: 15)
                    HStack {
                        Image(systemName: "dot.radiowaves.left.and.right")
                        Text("CPM")
                        Spacer()
                        Text(String(ble_handler.values.cpm))
                        Image(systemName: "circle.fill")
                            .animation(blink)
                            .foregroundColor(.red)
                            .opacity(ble_handler.impulse ? 1 : 0)
                    }
                    HStack {
                        Image(systemName: "dot.radiowaves.right")
                        Text("µSv/h")
                        Spacer()
                        Text(String(format: "%.2f", ble_handler.values.msvh))
                        Image(systemName: "circle.fill")
                            .animation(blink)
                            .foregroundColor(color)
                    }
                }
                Spacer()
                    .frame(height: 15)
                Group {
                    Text("Informations")
                        .fontWeight(.bold)
                        .font(.title)
                    Spacer()
                        .frame(height: 15)
                    Text("Am I in danger?")
                        .fontWeight(.bold)
                    Text("If the dot on µSv/h is green, you're good to go. A critical point is hit at 11 µSv/h and above. Deadly are values over 57 µSv/h.")
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
