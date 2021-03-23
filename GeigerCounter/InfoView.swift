//
//  InfoView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 24.11.20.
//

import SwiftUI

struct InfoView : View {
    
    @ObservedObject var state : MainState
    
    func close() {
        state.change_state(view: ViewState.SHOW)
    }
    
    var body : some View {
        VStack {
            
        }
        HStack {
            Spacer()
            VStack {
                Image("Radioactivity")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                Text("GeigerCounterApp")
            }
            Spacer()
        }.padding()
        VStack (alignment: .leading) {
            Group {
                Text("Info")
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
                    .frame(height: 15)
                HStack {
                    Text("Developed by Marco Combosch (2020 - 2021)")
                }
            }
            Spacer()
            Button(action: close) {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Back")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
            }
        }.padding()
        
    }
    
}
