//
//  VictoryView.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct VictoryView: View {
    let image: UIImage
    let count: Int
    @State var showing: Bool = false
    
    func getMessage(count: Int) -> String {
        switch count {
        case 0:
            return "E for effort."
        case 1:
            return "You stopped Junior from eating one drumstick, nice."
        case let x where x < 100:
            return "\(count) drumsticks have met their maker..."
        case let x where x < 70:
            return "You stopped \(count) drumsticks in their tracks!"
        default:
            return "\(count) drumsticks have been eliminated."
        }
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
            VStack {
                Spacer()
                Text(getMessage(count: count))
                if count > 1 {
                    Text("But there are more where they came from...")
                }
                Spacer()
                Button.init("💪🏽 SHARE 💪🏽") {
                    self.showing = true
                }
                .foregroundColor(.white)
                Divider()
                Button.init("To Launcher") {
                    AppController.singleton.toMainMenuView()
                }
                .foregroundColor(.white)
                Spacer()
            }
            
        }
        .sheet(isPresented: $showing) {
            SocialSharer(image: self.image, count: self.count)
        }
    }
}

//struct VictoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        VictoryView()
//    }
//}
