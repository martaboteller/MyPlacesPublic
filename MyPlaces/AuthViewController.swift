//
//  AuthViewController.swift
//  MyPlaces
//
//  Created by Laura Llunell on 24/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit
import Firebase

class AuthViewController: UIViewController {
    
  
    @IBOutlet weak var logIn: UIButton!
    
    var myImage: Data = Data()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Download task test
        let storage = Storage.storage()
        let globalReference = storage.reference()
        let ref = globalReference.child("demoJSON/demoPlaces.json")
        let ref2 = globalReference.child("demoImages/5.png")
        
        let dic = PlaceServices.shared.downloadImage(reference: ref2)
        // let data: Data = dic.keys.first!
        let downloadTask: StorageDownloadTask = dic.values.first!
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            print("Downloaded successfully")
        }
    }
    
  
    
    @IBAction func logInAction(_ sender: Any) {
        performSegue(withIdentifier: "AccessApp", sender: "UserNamePassword")
    }
    
    //func retrieveDemoImages () -> [Data] {
        //General variables
//        let storage = Storage.storage()
//        let globalReference = storage.reference()
//        var imageArray: [Data] = [Data()]
//
      
//        for i in 1...5 {
//            let demoImageRef = globalReference.child("demoImages/\(i).png")
//            print(demoImageRef.bucket)
//            print(demoImageRef.fullPath)
//            let imageData = PlaceServices.shared.downloadImage(reference: demoImageRef)
//            imageArray.append(imageData)
//        }
       // return imageArray
   // }
    
    
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "AccessApp" {

        }
    }
    
}
