//
//  ARView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 09.10.20.
//

import SwiftUI

struct ARView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    func close() {
        state.change_state(view: ViewState.SHOW)
    }
    
    var body : some View {
        ZStack {
            NavigationIndicator(ble_handler: ble_handler, state: state)
            VStack {
                Spacer()
                Spacer()
                Button(action: close) {
                    HStack {
                        Image(systemName: "camera.rotate.fill")
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
    
}
