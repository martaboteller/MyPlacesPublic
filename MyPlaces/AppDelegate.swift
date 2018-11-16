//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize Manager
        let manager = PlaceManager.shared
        
        //Define paths and files
        let fileManager = FileManager.default
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let templateFile = docsPath.appendingPathComponent("savedPlaces.json")
        let userdataFile = docsPath.appendingPathComponent("userPlaces.json")
        var path: URL
       
        //Create userdataFile
        if(!fileManager.fileExists(atPath: userdataFile.path)){
            fileManager.createFile(atPath: userdataFile.path, contents: nil, attributes: nil)
        }
        
        //Save default places into templateFile
        if(!fileManager.fileExists(atPath: templateFile.path)){
            fileManager.createFile(atPath: templateFile.path, contents: nil, attributes: nil)
        }
        if !PlaceManager.shared.userHasData(path: templateFile){
            if PlaceManager.shared.writeToJson(fileName: templateFile, places: PlaceManager.shared.somePlaces()){
                print("Template data correctly saved into file")
            }else{
                print("Error saving template data")
            }
        }
       
        //Read data and append it into manager
        if PlaceManager.shared.userHasData(path: userdataFile){
           path = userdataFile
        } else {
           path = templateFile
        }
        //Serialize JSON from file
        do{
           let jsonData = try Data.init(contentsOf: path)
           let places = PlaceManager.shared.placesFrom(jsonData: jsonData)
                for place in places {
                    //print(place)
                    manager.append(place)
                }
        } catch {
            print ("Unable to read from : " + path.path)
        }
    
    return true
    }
}
