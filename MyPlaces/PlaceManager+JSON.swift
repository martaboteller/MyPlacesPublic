//
//  PlaceManager+JSON.swift
//  MyPlaces
//
//  Created by Marta Boteller on 14/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit
import Firebase

extension PlaceManager  {
    
    //Checks if there is stored data at specific file path
    //If file is emtpy returns "false"
    func userHasData (path: URL)-> Bool {
        var result: Bool = true
        do{
            let jsonData = try Data.init(contentsOf: path)
            let places = PlaceManager.shared.placesFrom(jsonData: jsonData)
            if places.count == 0 {
                result = false
            }
        }catch {
            print(error)
            result = false
        }
        return result
    }
    
    //Encodes an array of Places into json
    //Returns json data
    func jsonFrom (places: [Place]) -> Data?{
        var jsonData: Data? = nil
        let jsonEncoder = JSONEncoder()
        do{
            jsonData = try jsonEncoder.encode(places)
        }catch{
            return nil
        }
        return jsonData
    }
    
    //Reads data from Json and serializes it
    //Returns an array of Places
    func placesFrom (jsonData: Data) -> [Place]{
        let jsonDecoder = JSONDecoder()
        let places: [Place] 
        do{
            places = try jsonDecoder.decode([Place].self, from: jsonData)
        }catch{
            return []
        }
        return places
    }
    
}
