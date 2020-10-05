//
//  SpashView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import SwiftUI

struct SplashView : View {
    
    @State var active : Bool = false
    
    func load_devices() -> some View {
        return Text("")
    }
    
    var body : some View {
        VStack {
            if self.active {
                self.load_devices()
            } else {
                Image("Radioactivity")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.0)
                Text("Geiger Counter")
                    .font(.custom("kremlin", size: 35))
                    .padding()
                Text("Version 0.1")
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.active = true
                }
            }
        }
    }
    
}

struct SpashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
