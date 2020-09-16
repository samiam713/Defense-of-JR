//
//  SocialSharer.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct SocialSharer: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    init(image: UIImage, count: Int) {
        self.activityItems = [image,"I defended Junior from eating \(count) \(count > 70 ? "(that's \(count <= 100 ? "probably " :"")more than you can count) " : "")drumstick\(count == 1 ? "" : "s"). He'll thank me when he's older..."]
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}
