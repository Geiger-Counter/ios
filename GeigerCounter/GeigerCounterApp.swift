//
//  GeigerCounterApp.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 22.09.20.
//

import SwiftUI

@main
struct GeigerCounterApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

struct GeigerCounterApp_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
