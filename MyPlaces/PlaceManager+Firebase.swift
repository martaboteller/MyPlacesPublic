//
//  PlaceManager+Firebase.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import Firebase



extension PlaceManager {
    
    
    
    /*func readImageFromFirebase (imageName: String ) -> Data? {
        
        var imageData : Data?
        
        let storage = Storage.storage()
        let storagePath = "gs://myplaces-2018mb.appspot.com"
        let spaceRef = storage.reference(forURL: storagePath)
        let newRef = spaceRef.child("/demoImages/test3.png")
        
        print(newRef.bucket)
        print(newRef.fullPath)
        
        
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagePath = docsPath.appendingPathComponent("imatgeCifo.png")
        let data1 = UIImage(contentsOfFile: imagePath.path)?.pngData()
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        
        
        let uploadUserProfileTask = newRef.putData(data1!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error occurred: \(error)")
                return
            }
            print("download url for profile is \(metadata)")
        }
        
        let downloadUserProfileTask = newRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error \(error)")
            } else {
                imageData = UIImage(data: data!)?.pngData()
            }
        }
        
        let progressObserver = uploadUserProfileTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        
        let progressObserver2 = downloadUserProfileTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        
        return imageData
    }*/
}