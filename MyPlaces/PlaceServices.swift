//
//  PlaceServices.swift
//  MyPlaces
//
//  Created by Marta Boteller on 24/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit
import Firebase

class PlaceServices {
    
    static let shared = PlaceServices()
    
    enum metadataContentType: String {
        case image
        case json
    }
    
    private init() {
    }
    
    //Function that uploads data into Firebase storage
    func uploadData (reference: StorageReference, dataToUpload: Data, metadataContentType: String)  -> StorageTask {
        
        //Define metadata to be uploaded
        let metadata = StorageMetadata()
        if  metadataContentType == "image" {
            metadata.contentType = "image/png"
        }else{
            metadata.contentType = "application/json"
        }
        
        //Proceed to upload data
        let uploadTask = reference.putData(dataToUpload, metadata: metadata){(metadata,error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print ("An error occurred \(error)")
            } else {
                print("Data uploaded!")
            }
        }
        return uploadTask
    }
    
    //Function that downloads an image from Firebase storage
    func downloadImage (reference: StorageReference) -> [Data : StorageDownloadTask] {
        var myReturn: [Data : StorageDownloadTask] = [Data: StorageDownloadTask]()
        var imageData: Data = Data()
        let downloadTask = reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    imageData = myImage.pngData()!
                }
            }
        }
        myReturn = [imageData : downloadTask]
      return myReturn
    }
    
    //Function that downloads a file from Firebase storage
    func downloadFile (reference: StorageReference) -> [[Place]: StorageDownloadTask] {
        var myReturn: [[Place] : StorageDownloadTask] = [[Place]: StorageDownloadTask]()
        var placesData: [Place] = [Place]()
        let downloadTask = reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
            } else {
                if let _data  = data {
                    let placesData =  PlaceManager.shared.placesFrom(jsonData: data!)
                }
            }
        }
        myReturn = [placesData : downloadTask]
        return myReturn
    }
    
    //Testing database writing
    /*ref.child("UsersData").childByAutoId().setValue("Hello, World!")
     do {
     let defaultDocsPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
     let defaultFileURL: URL  = defaultDocsPath.appendingPathComponent("userPlaces.json")
     let jsonData = try Data.init(contentsOf: defaultFileURL)
     
     let myArray: NSArray = PlaceManager.shared.placesFrom(jsonData: jsonData) as NSArray
     let arrayOne: NSDictionary = ["Hi":"Hello", "Hello, World!": "Again","Number": 42]
     ref.child("UsersData").setValue(arrayOne)
     
     } catch {
     print (error)
     }*/
    
   
}
