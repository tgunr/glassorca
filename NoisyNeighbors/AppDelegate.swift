//
//  AppDelegate.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var stagedIncident: Incident?
    var version = "0.2"
    var firstLaunch = false
    var apiKey = "keyx0gx0iobbmtuZl"
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Neighbor.restoreUserDefaults()
        Incident.restoreUserDefaults()
//        let fm = FileManager.default
//        let icloudToken = fm.ubiquityIdentityToken
//        let userDefaults: UserDefaults = UserDefaults.standard
//        if icloudToken != nil {
//            let docs = FileManager().urls(for: .cachesDirectory, in: .userDomainMask).first!
//            let newTokenData = NSKeyedArchiver.archiveRootObject(icloudToken, toFile: docs.)
//            userDefaults.set(icloudToken, forKey: "net.polymicro.noisyneighbors.UbiquityIdentityToken")
//        } else {
//            userDefaults.removeObject(forKey: "net.polymicro.noisyneighbors.UbiquityIdentityToken")
//        }
//        let nc = NotificationCenter.default
//        nc.addObserver(self, selector: (iCloudAccountAvailabilityChanged:), name: NSUbiquityIdentityDidChangeNotification, object: nil)
//        if (icloudToken && firstLaunchWithiCloudAvailable) {
//
//        }
            return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func addNeighbor(_ theNeighbor: Neighbor) {
        gNeighbors.append(theNeighbor)
        Neighbor.saveUserDefaults()
    }

    func saveNeighbor(_ theNeighbor: Neighbor) {
        let found = gNeighbors.index(of: theNeighbor)
        if found != nil {
            gNeighbors[found!] = theNeighbor
            Neighbor.saveUserDefaults()
        }
    }
    
    func removeNeighbor(_ theNeighbor: Neighbor) {
        let found = gNeighbors.index(of: theNeighbor)
        if found != nil {
            gNeighbors.remove(at: found!)
            Neighbor.saveUserDefaults()
        }
    }

    func stageIncident(_ incident: Incident) {
        self.stagedIncident = incident
    }

    func unstageIncident() {
        // Save any previous stage incident
        if self.stagedIncident != nil {
            self.stagedIncident!.stopped = Date()
            gIncidents.append(stagedIncident!)
            Incident.saveUserDefaults()
        }
        self.stagedIncident = nil
    }
}

