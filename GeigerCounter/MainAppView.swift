//
//  MainAppView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 08.10.20.
//

import SwiftUI

enum ViewState {
    case SEARCH, SHOW, INFO, AR
}

open class MainState : ObservableObject {
    @Published var view : ViewState = ViewState.SEARCH
    @Published var device : Device? = nil
    
    func change_state(view : ViewState, device : Device? = nil) {
        self.view = view
        if(device != nil) {
            self.device = device
        }
    }
}

struct MainAppView : View {
    
    @ObservedObject var ble_handler = BLEHandler()
    @ObservedObject var state : MainState = MainState()
    var device : Device?
    
    public var body : some View {
        switch(self.state.view) {
            case ViewState.SEARCH:
                return AnyView(SearchView(ble_handler: ble_handler, state: state))
            case ViewState.SHOW:
                if(ble_handler.connected) {
                    return AnyView(ShowView(ble_handler: ble_handler, state: state))
                } else {
                    return AnyView(SearchView(ble_handler: ble_handler, state: state))
                }
            case ViewState.INFO: return AnyView(InfoView(state: state))
            case ViewState.AR: return AnyView(ARView(ble_handler: ble_handler, state: state))
        }
        
    }
    
}
