//
//  AIView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 08.10.20.
//

import SwiftUI
import CameraView

struct AIView : View {
    
    @ObservedObject var ble_handler : BLEHandler
    @ObservedObject var state : MainState
    
    var body : some View {
        NavigationView {
            VStack {
                CameraView()
            }
        }
    }
    
}
