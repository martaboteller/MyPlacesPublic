//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //create singleton instance of ManagerPlaces
        let manager = ManagerPlaces.shared
        
        //get images and data to test with
        let image1 = UIImage(named:"lakeMoraine.png")
        let image2 = UIImage(named:"cadaques.png")
        let image3 = UIImage(named:"rialtoVenecia.png")
        let data1 = image1?.pngData()
        let data2 = image2?.pngData()
        let data3 = image3?.pngData()
    
        
        var pl = Place(name:"Lake Moraine",description:"Llac de muntanya localitzat al Parc Nacional de Banff, a Alberta, Canadà.",image_in:data1)
        manager.append(pl)
        
        pl = Place(name:"Cadaqués",description:"Poble més oriental de la península ibèrica a la comarca de l'Alt Empordà, Girona",image_in:data2)
        manager.append(pl)
        
        pl = Place(name:"Venecia",description:"Ciutat italiana amb centre històric declarat patrimoni de la humanitat per l'UNESCO",image_in:data3)
        manager.append(pl)
        
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


}

