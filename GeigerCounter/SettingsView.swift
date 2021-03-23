//
//  SettingsView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 08.10.20.
//

import SwiftUI

struct SettingsView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    init(ble_handler : BLEHandler, state : MainState) {
        self.ble_handler = ble_handler
        self.state = state
    }
    
    func back() {
        state.change_state(view: ViewState.SHOW)
    }
    
    var body : some View {
        VStack {
            HStack {
                VStack {
                    Image("Radioactivity")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                    Text("GeigerCounterApp")
                }
                Spacer()
                Text("")
            }
            Spacer()
            Button(action: back) {
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Text("Back")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
            }
        }
    }
    
}
