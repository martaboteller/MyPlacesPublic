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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiKey: String = "AIzaSyBFMlj-NnQlPJyKbEhxBEIOsADL9A_sz0A"
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Provide APIKey for GoogleMaps and GooglePlaces Pods
         GMSServices.provideAPIKey(apiKey)
         GMSPlacesClient.provideAPIKey(apiKey)
        
        //Initialize Manager
        let manager = PlaceManager.shared
        
        //Define paths and files where data will be stored
        let fileManager = FileManager.default
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let templateFile = docsPath.appendingPathComponent("savedPlaces.json")
        let userdataFile = docsPath.appendingPathComponent("userPlaces.json")
        var path: URL
        print(userdataFile)
        
        //Create userdataFile/templateFile if it does not exist
        //Save default places if templateFile is empty
        if(!fileManager.fileExists(atPath: userdataFile.path)){
            fileManager.createFile(atPath: userdataFile.path, contents: nil, attributes: nil)
        }
        if(!fileManager.fileExists(atPath: templateFile.path)){
            fileManager.createFile(atPath: templateFile.path, contents: nil, attributes: nil)
        }
        if !PlaceManager.shared.userHasData(path: templateFile){
            if PlaceManager.shared.writeToJson(fileName: templateFile, places: PlaceManager.shared.somePlaces()){
                print("Data correctly saved into tempalteFile")
            }
        }
       
        //If user has saved data use userdataFile otherwise use templateFile
        if PlaceManager.shared.userHasData(path: userdataFile){
           path = userdataFile
        } else {
           path = templateFile
        }
        
        //Read data from stored file and append it into manager
        do{
           let jsonData = try Data.init(contentsOf: path)
           let places = PlaceManager.shared.placesFrom(jsonData: jsonData)
                for place in places {
                    manager.append(place)
                }
        } catch {
            print ("Unable to read from : " + path.path)
        }
    
    return true
    }
}
