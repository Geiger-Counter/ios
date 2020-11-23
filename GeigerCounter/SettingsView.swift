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
                Button(action: back) {
                    Image(systemName: "arrow.left.circle")
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
                Text("")
            }
            .padding()
        }
    }
    
}
