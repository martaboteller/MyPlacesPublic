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
    
    
    //Returns default data
    func somePlaces()-> [Place]{
    
        //Prepare images into data
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let image1 = docsPath.appendingPathComponent("test3.png")
        let image2 = docsPath.appendingPathComponent("imatgeRostisseria.png")
        let image3 = docsPath.appendingPathComponent("imatgeCifo.png")
        let image4 = docsPath.appendingPathComponent("imatgeCosmoCaixa.png")
        let image5 = docsPath.appendingPathComponent("imatgeParcG.png")
        let data1 = UIImage(contentsOfFile: image1.path)?.pngData()
        let data2 = UIImage(contentsOfFile: image2.path)?.pngData()
        let data3 = UIImage(contentsOfFile: image3.path)?.pngData()
        let data4 = UIImage(contentsOfFile: image4.path)?.pngData()
        let data5 = UIImage(contentsOfFile: image5.path)?.pngData()
        
        let p1 = Place(name: "UOC @22", descriptionPlace: "Seu de la Universitat Oberta de Catalunya",image_in: data1, stringImage: "imatgeUOC.png", type: Place.PlaceType.generic,location: CLLocationCoordinate2D(latitude: 41.415018, longitude: 2.133570))
        
        let p2 = Place(name: "Rostisseria Lolita", descriptionPlace: "Els millors pollastres de Sant Cugat", image_in: data2, stringImage: "imatgeRostisseria.png", type: Place.PlaceType.generic,location: CLLocationCoordinate2D(latitude: 41.482452, longitude: 2.091065))
        
        let p3 = Place(name: "CIFO LHospitalet", descriptionPlace: "Seu del Centre d'Innovació i Formació per a l 'Ocupació", image_in: data3, stringImage: "imatgeCifo.png", type: Place.PlaceType.generic, location: CLLocationCoordinate2D(latitude: 41.359900, longitude: 2.113988))
        
        let p4 = PlaceTourist(name: "CosmoCaixa", descriptionPlace: "Museu de la Ciència de Barcelona", image_in: data4, stringImage: "imatgeCosmoCaixa.png", discount_tourist: "50", location: CLLocationCoordinate2D(latitude: 41.413237, longitude: 2.131519))
        
        let p5 = PlaceTourist(name: "Park Güell", descriptionPlace: "Obra d'Antoni Gaudí a Barcelona", image_in: data5, stringImage: "imatgeParcG.png", discount_tourist: "10", location: CLLocationCoordinate2D(latitude: 41.414478, longitude: 2.152647))
        
        return [p1,p2,p3,p4,p5]
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
    
    
    
    //Saves image at default documents directory assigning a unique name
    //Returns image name
    func saveImage(image: Data)-> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "Image:" + UUID().uuidString + ".png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // Check if the destination file already exists
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try image.write(to: fileURL)
            } catch {
                print("Error saving image: " + fileName)
            }
        }
       return fileName
    }
    
    //Deletes image from default documents directory
    //Returns "false" if an error has occurred
    func deleteImage (imageName: String)-> Bool{
        var myBool: Bool = true
        let fileManager = FileManager.default
        let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        
        // Check if the destination file already exists
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try fileManager.removeItem(atPath: imageURL.path)
            } catch {
                print("Error deleting image: " + imageURL.path)
                myBool = false
            }
        }
        return myBool
    }
   
    //Saves all places stored at manager into specific file
    //Returns "false" if an error has occurred
    func writeToJson (fileName: URL, places: [Place]) -> Bool {
        var myBool: Bool = true
        do{
            let jsonData = PlaceManager.shared.jsonFrom(places: places)
            try jsonData!.write(to: fileName)
            //Print result in console
            //let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
        }catch{
            print("Error saving json into: " + fileName.path)
            myBool = false
        }
        return myBool
    }
    
}
