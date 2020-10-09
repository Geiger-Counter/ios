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
    
    @State var ssid : String = ""
    @State var password : String = ""
    @State var api_endpoint : String = ""
    @State var api_username : String = ""
    @State var api_password : String = ""
    @State var api_token : String = ""
    @State var auditive : Bool = false
    
    init(ble_handler : BLEHandler, state : MainState) {
        self.ble_handler = ble_handler
        self.state = state
        self.ssid = ble_handler.values.settings.ssid
        self.password = ble_handler.values.settings.password
        self.api_endpoint = ble_handler.values.settings.endpoint
        self.api_username = ble_handler.values.settings.username
        self.api_token = ble_handler.values.settings.token
        self.auditive = ble_handler.values.settings.auditive
    }
    
    func back() {
        state.change_state(view: ViewState.SHOW)
    }
    
    func save() {
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
            VStack (alignment: .leading) {
                Form {
                    Section(header: Text("WiFi")) {
                        TextField("SSID", text: $ssid)
                        TextField("Password", text: $password)
                    }
                    Section(header: Text("API")) {
                        TextField("Endpoint", text: $api_endpoint)
                        TextField("Username", text: $api_username)
                        TextField("Password", text: $api_password)
                        TextField("Token", text: $api_token)
                    }
                    Section(header: Text("Device")) {
                        Toggle(isOn: $auditive) {
                            Text("Radiation Signal")
                        }
                    }
                }
                .navigationBarTitle("Settings")
            }
            Spacer()
            Button(action: save){
                HStack{
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
            }
        }
    }
    
}
