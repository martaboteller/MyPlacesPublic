//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiKey: String = "AIzaSyBFMlj-NnQlPJyKbEhxBEIOsADL9A_sz0A"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        //Provide APIKey for GoogleMaps and GooglePlaces Pods
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
        
        FirebaseApp.configure()
        return true
    }
    
}
