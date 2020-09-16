//
//  ManualView.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct ManualView: View {
    var body: some View {
        VStack {
            Text("1: Fire up the simulator.")
            Text("2: Scan a horizontal surface with camera.")
            Text("3: Tap to anchor the game in reality.")
            Text("4: Adjust size, rotation, scale as desired.")
            Text("5: Press play.")
            Text("6 - ∞: Tap the incoming drumstick.")
            Divider()
            Image("Manual")
                .resizable()
            .padding()
        }
        .navigationBarTitle("Manual")
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
