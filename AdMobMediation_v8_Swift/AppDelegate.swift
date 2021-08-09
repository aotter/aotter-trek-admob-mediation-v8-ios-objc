//
//  AppDelegate.swift
//  AdMobMediation_v8_Swift
//
//  Created by JustinTsou on 2021/5/31.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let adItemViewController = AdItemViewController(nibName: "AdItemViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: adItemViewController)
        
        window.rootViewController = nav;
        self.window = window;
        window.makeKeyAndVisible()
        
        
        // Googles Ads SDK init
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Aotter SDK init
        
        // Please fill in you ClientId and secret
        AotterTrek.sharedAPI()?.initTrekService(withClientId: "Your Client id", secret: "Your secret")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

