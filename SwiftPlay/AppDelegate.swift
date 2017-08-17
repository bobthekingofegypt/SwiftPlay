//
//  AppDelegate.swift
//  SwiftPlay
//
//  Created by Richard Martin on 03/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import GoogleMaterialDesignIcons

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.black
        navigationBarAppearance.alpha = 1.0;
        navigationBarAppearance.isTranslucent = false
        
        let image = UIImage(named: "back-icon")
        navigationBarAppearance.backIndicatorImage = image
        navigationBarAppearance.backIndicatorTransitionMaskImage = image
        
        let font = UIFont(name: GoogleIconName, size: 15.0)
        
        // Back button
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState.normal)

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = UIViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        let viewController = SplitViewController()
        
        navigationController.pushViewController(viewController, animated: false)
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }

}

