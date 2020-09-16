//
//  ContentView.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI
import RealityKit

struct RealityView: View {
    @ObservedObject var controller: Reality
    var body: some View {
        VStack {
            ZStack {
                ARViewContainer(reality: self.controller)
                if controller.state.placing() {
                    Text("Tap to place!")
                        .foregroundColor(.white)
                        .italic()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.black)
                    )
                }
            }
            Button.init("Return to Main Menu") {
                AppController.singleton.toMainMenuView()
            }
        }
        .edgesIgnoringSafeArea([.top,.leading,.trailing])
    }
}

struct ARViewContainer: UIViewRepresentable {
    unowned let reality: Reality
    init(reality: Reality) {
        self.reality = reality
    }
    func makeUIView(context: Context) -> ARView {
        return reality.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        RealityView(controller: Reality())
    }
}
#endif
