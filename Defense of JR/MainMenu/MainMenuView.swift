//
//  MainMenuView.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))")
                Image("WholesomePicture")
                    .resizable()
                NavigationLink(destination: ManualView()) {
                    Text("Read the manual")
                        .padding()
                }
                Button.init("Fire up the simulator...", action: {
                    AppController.singleton.toRealityView()
                })
                    .padding()
            }
        }
        .navigationBarTitle("Launcher")
    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
