//
//  AppDelegate.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dataController = DataController()
    
    // Checks when the list of teams was last updated.
    // If this is first launch, or it's been more than 4 weeks, update the team list.
    // Since this data almost never changes, we rarely need to grab it from the NHL API.
    func checkForLastUpdate() {
        if UserDefaults.standard.bool(forKey: K.UserDefaultValues.hasLaunchedBefore) {
            let lastUpdateDate = UserDefaults.standard.object(forKey: K.UserDefaultValues.lastUpdateDate) as! Date
    
            // check if its been more than 4 weeks since the last update
            if lastUpdateDate.distance(to: Date()) > (604800 * 4) {
                dataController.updateTeams()
            }
        } else {
            UserDefaults.standard.set(true, forKey: K.UserDefaultValues.hasLaunchedBefore)
            UserDefaults.standard.synchronize()
            dataController.updateTeams()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // checkForLastUpdate()
        
        // check if this is the first launch. If so, set up some user defaults
        if !UserDefaults.standard.bool(forKey: K.UserDefaultValues.hasLaunchedBefore) {
            UserDefaults.standard.set(true, forKey: K.UserDefaultValues.hasLaunchedBefore)
            UserDefaults.standard.set([Int](), forKey: K.UserDefaultValues.favouritePlayers)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    // MARK: - Core Data Saving support

    func saveContext () {
        let context = dataController.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

