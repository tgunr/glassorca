//
//  AppDelegate.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var neighbors: [Neighbor] = [Neighbor]()
    var incidents: [Incident] = [Incident]()
    var stagedIncident: Incident?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadNeighbors()
        //        neighbors = realm.objects(Neighbor.self).filter(predicate)
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

    func saveNeighbors() {
        let nd = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let ArchiveURL = nd.appendingPathComponent("neighbors").standardizedFileURL.path
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(neighbors, toFile: ArchiveURL)
        if !isSuccessfulSave {
            print("Failed to save neighbors...")
        }
    }
    
    func loadNeighbors() {
        let u = Neighbor.ArchiveURL
        let n =  NSKeyedUnarchiver.unarchiveObject(withFile: u) as? [Neighbor]
        if n != nil {
            neighbors = n!
        }
    }
    
    func addNeighbor(_ theNeighbor: Neighbor) {
        neighbors.append(theNeighbor)
        saveNeighbors()
    }

    func saveNeighbor(_ theNeighbor: Neighbor) {
        let found = neighbors.index(of: theNeighbor)
        if found != nil {
            neighbors[found!] = theNeighbor
            saveNeighbors()
        }
    }
    
    func removeNeighbor(_ theNeighbor: Neighbor) {
        let found = neighbors.index(of: theNeighbor)
        if found != nil {
            neighbors.remove(at: found!)
            saveNeighbors()
        }
    }

    func stageIncident(_ incident: Incident) {
        // Save any previous stage incident
        if self.stagedIncident != nil {
            self.stagedIncident!.stopped = Date()
            self.incidents.append(stagedIncident!)
        }
        self.stagedIncident = incident
    }
}

