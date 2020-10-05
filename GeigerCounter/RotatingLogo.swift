//
//  RotatingLogo.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 05.10.20.
//

import Foundation
import SwiftUI

struct RotatingLogo : View {
    
    var duration : Double
    
    @State private var is_running = false
    
    var rotate : Animation {
        Animation.linear(duration: duration)
            .repeatForever(autoreverses: false)
    }
    
    var body : some View {
        Image("Radioactivity")
            .resizable()
            .scaledToFit()
            .frame(width: 110)
            .rotationEffect(Angle(degrees: is_running ? 360 : 0))
            .animation(rotate)
            .onAppear() {
                self.is_running = true
            }
    }
    
}

struct RotatingLogo_Previews: PreviewProvider {
    static var previews: some View {
        RotatingLogo(duration: 5)
    }
}
