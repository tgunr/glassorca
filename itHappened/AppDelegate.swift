//
//  AppDelegate.swift
//  itHappened
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit
import WatchConnectivity

var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

enum ShortcutIdentifier: String {
    case Start
    case Stop
    case Share

    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: last)
    }

    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)" as String
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let ArchiveURL: String = DocumentsDirectory.appendingPathComponent("configure").standardizedFileURL.path
    var window: UIWindow?
    var version = "0.2"
    var firstLaunch = false
    var apiKey = "keyx0gx0iobbmtuZl"
    var defaults = UserDefaults.init(suiteName: "itHappened")
    var wormhole: MMWormhole!

    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    var shortcutItem: UIApplicationShortcutItem?
    var shortCutType: String?

    func saveUserDefaults() {
        let result = NSKeyedArchiver.archiveRootObject(gOccurances, toFile: ArchiveURL)
        if !result {
            print("Failed to save gOccurances...")
        }
        let strings = gOccurances.map({
            $0.label
        })
        defaults?.set(strings, forKey: "Neighbors")
    }
    
    func restoreUserDefaults() {
        NSLog("Restoring")
        let result =  NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL) as? [Occurance]
        if result != nil {
            gOccurances = result!
        } else {
            print("Failed to restore gOccurances...")
        }
    }
    
    func initWormhole() {
        let fm = FileManager()
        if fm.containerURL(forSecurityApplicationGroupIdentifier: APPGROUP) != nil {
            wormhole = MMWormhole(applicationGroupIdentifier: APPGROUP, optionalDirectory: "wormhole")
            wormhole?.listenForMessage(withIdentifier: "sendNeighborList", listener: { (messageObject) -> Void in
                if let _: AnyObject = messageObject as AnyObject? {
                    // Do something
                }
            })
        } else {
            NSLog("ERROR: Setting AppGroup %s failed", APPGROUP)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.restoreUserDefaults()
        self.saveUserDefaults()
        IncidentList.sharedInstance.restoreUserDefaults()

        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true

        // If a shortcut was launched, display its information and take the appropriate action
        shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
        if shortcutItem != nil {

            launchedShortcutItem = shortcutItem

            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        }

        // Install initial versions of our two extra dynamic shortcuts.
        let shortcutItems = application.shortcutItems
        if (shortcutItems != nil) {
            // Construct the items.
            let shortcut1 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Start.type, localizedTitle: "Start", localizedSubtitle: "Start new incident", icon: UIApplicationShortcutIcon(type: .task), userInfo: [
                    AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.task.rawValue
            ]
            )
            let shortcut2 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Stop.type, localizedTitle: "Stop", localizedSubtitle: "Stop current incident", icon: UIApplicationShortcutIcon(type: .taskCompleted), userInfo: [
                    AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.taskCompleted.rawValue
            ]
            )
            let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Share.type, localizedTitle: "Share", localizedSubtitle: "Share itHappened", icon: UIApplicationShortcutIcon(type: .share), userInfo: [
                    AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.share.rawValue
            ]
            )

            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [shortcut3, shortcut2, shortcut1]
        }

        if WCSession.isSupported() {
            let defaultSession = WCSession.default()
            defaultSession.delegate = WatchConnectivityManager.sharedConnectivityManager
            defaultSession.activate()
        }
        
        initWormhole()
        return shouldPerformAdditionalDelegateHandling
    }

    var launchedShortcutItem: UIApplicationShortcutItem?

    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        return true
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        self.shortcutItem = shortcutItem
        let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem)
        completionHandler(handledShortCutItem)
}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        guard let shortcut = launchedShortcutItem
                else {
            return
        }

        let _ = handleShortCutItem(shortcutItem: shortcut)

        launchedShortcutItem = nil
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func addOccurance(_ theOccurance: Occurance) {
        gOccurances.append(theOccurance)
        self.saveUserDefaults()
    }

    func saveOccurance(_ theOccurance: Occurance) {
        let found = gOccurances.index(of: theOccurance)
        if found != nil {
            gOccurances[found!] = theOccurance
            self.saveUserDefaults()
        }
    }
    
    func removeOccurance(_ theOccurance: Occurance) {
        let found = gOccurances.index(of: theOccurance)
        if found != nil {
            gOccurances.remove(at: found!)
            self.saveUserDefaults()
        }
    }

    func addType(_ theType: OccuranceType) {
        gOccuranceTypes.append(theType)
        self.saveUserDefaults()
    }
    
    func saveType(_ theType: OccuranceType) {
        let found = gOccuranceTypes.index(of: theType)
        if found != nil {
            gOccuranceTypes[found!] = theType
            self.saveUserDefaults()
        }
    }
    
    func removeType(_ theType: OccuranceType) {
        let found = gOccuranceTypes.index(of: theType)
        if found != nil {
            gOccuranceTypes.remove(at: found!)
            self.saveUserDefaults()
        }
    }
    
    func longPress(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizerState.began
        {
            let alertController = UIAlertController(title: nil, message:
                "Long-Press Gesture Detected", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.inputViewController?.present(alertController, animated: true, completion: nil)
        }
    }

}

