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
        
        // We add some test places so the app can show some information when it loads. When we start creating our own real
        // content we will need to remove this part, of course.
        let manager = PlaceManager.shared
        
        //Get images and data to test with
        let data1 = UIImage(named:"imatgeUOC.png")?.pngData()
        let data2 = UIImage(named:"imatgeRostisseria.png")?.pngData()
        let data3 = UIImage(named:"imatgeCifo.png")?.pngData()
        let data4 = UIImage(named:"imatgeCosmoCaixa.png")?.pngData()
        let data5 = UIImage(named:"imatgeParcG.png")?.pngData()
        
        let someTestPlaces = [
            Place(name: "UOC 22@",
                  description: "Seu de la Universitat Oberta de Catalunya",
                  image_in: data1),
            Place(name: "Rostisseria Lolita",
                  description: "Els millors pollastres de Sant Cugat",
                  image_in: data2),
            Place(name: "CIFO L'Hospitalet",
                  description: "Seu del Centre d'Innovació i Formació per a l'Ocupació",
                  image_in: data3),
            PlaceTourist(name: "CosmoCaixa",
                         description: "Museu de la Ciència de Barcelona",
                         discount_tourist: "50%", image_in: data4),
            PlaceTourist(name: "Park Güell",
                         description: "Obra d'Antoni Gaudí a Barcelona",
                         discount_tourist: "10%", image_in: data5)
        ]
        
       for place in someTestPlaces {
            manager.append(place)
        }
        
        return true
    }
   
}
