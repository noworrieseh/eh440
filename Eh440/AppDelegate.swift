//
//  AppDelegate.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-25.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController: DrawerController!
//  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Register Defaults
        let defaults = UserDefaults.standard
        var appDefaults: [String:AnyObject] = [:]
        appDefaults["refresh_interval"] = 604800 as AnyObject
        appDefaults["reset_cache"] = false as AnyObject
        defaults.register(defaults: appDefaults)
        defaults.synchronize()
        
        // Check for Reset
        if defaults.bool(forKey: "reset_cache") {
            print("Force reset")
            defaults.set(false, forKey: "reset_cache")
            
            AlbumDetails.reset()
            EventDetails.reset()
            VideoDetails.reset()
            VideoLists.reset()

        } // if

        // Load Data
        AlbumDetails.get()
        EventDetails.get()
        VideoDetails.get()
        VideoLists.get()
        BioDetails.get()
        
        let menuController = MenuController()
        let viewController = HomeViewController()

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.restorationIdentifier = "ExampleCenterNavigationControllerRestorationKey"
        let menuNavController = UINavigationController(rootViewController: menuController)
        menuNavController.restorationIdentifier = "ExampleLeftNavigationControllerRestorationKey"

        self.drawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: menuNavController, rightDrawerViewController: nil)
        self.drawerController.showsShadows = false
        
        self.drawerController.restorationIdentifier = "Drawer"
        self.drawerController.maximumRightDrawerWidth = 200.0
        self.drawerController.maximumLeftDrawerWidth = 250.0
        self.drawerController.shouldStretchDrawer = false
        self.drawerController.openDrawerGestureModeMask = .all
        self.drawerController.closeDrawerGestureModeMask = .all

/*
        self.drawerController.drawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) in
            let block = ExampleDrawerVisualStateManager.sharedManager.drawerVisualStateBlockForDrawerSide(drawerSide)
            block?(drawerController, drawerSide, percentVisible)
        }
*/
        
        self.window?.rootViewController = self.drawerController
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterFullScreen), name: Notification.Name("MediaEnterFullScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willExitFullScreen), name: Notification.Name("MediaExitFullScreen"), object: nil)
        
        // Override point for customization after application launch.
        return true
    }
    
    var isFullScreen = false

    @objc func willEnterFullScreen (notification: NSNotification) {
        print("ENTER")
        isFullScreen = true
    }
    
    @objc func willExitFullScreen (notification: NSNotification) {
        print("EXIT")
        isFullScreen = false
    }
    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let presentedViewController = window?.rootViewController?.presentedViewController {
            let className = String(describing: type(of: presentedViewController))
            if ["MPInlineVideoFullscreenViewController", "MPMoviePlayerViewController", "AVFullScreenViewController"].contains(className) {
                return UIInterfaceOrientationMask.allButUpsideDown
            }
        }
        
        return UIInterfaceOrientationMask.portrait
        
        //return isFullScreen == true ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.Portrait
    }    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

