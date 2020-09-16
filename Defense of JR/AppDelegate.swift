//
//  AppDelegate.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import UIKit
import SwiftUI

class AppController {
    static var singleton: AppController!
    
    let window: UIWindow
    var state: State = .mainMenu
    enum State {
        case mainMenu
        case reality(Reality)
        case victory
    }
    
    init() {
        self.window = .init(frame: UIScreen.main.bounds)
        self.window.makeKeyAndVisible()
        toMainMenuView()
    }
}

extension AppController {
    func toMainMenuView() {
        state = .mainMenu
        window.rootViewController = UIHostingController(rootView: MainMenuView())
    }
        func toRealityView() {
            let reality = Reality()
            state = .reality(reality)
            window.rootViewController = UIHostingController(rootView: RealityView(controller: reality))
        }
    
    func toVictoryView(image: UIImage, count: Int) {
        let prev = UserDefaults.standard.integer(forKey: "HighScore")
        if count > prev {
            UserDefaults.standard.set(count, forKey: "HighScore")
        }
        state = .victory
        window.rootViewController = UIHostingController(rootView: VictoryView(image: image, count: count))
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create the SwiftUI view that provides the window contents.
        AppController.singleton = .init()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        switch AppController.singleton.state {
        case .reality(let reality):
            switch reality.state {
            case .placed(let sim):
                sim.pauseSim()
            default:
                return
            }
        default:
            return
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

