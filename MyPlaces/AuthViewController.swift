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
  
    override func viewWillAppear(_ animated: Bool) {
       
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // - TEST -
        //Download task 1
        let storage = Storage.storage()
        let globalReference = storage.reference()
        let ref = globalReference.child("demoJSON/demoPlaces.json")
        let dic = PlaceServices.shared.downloadFile(reference: ref)
        let data: [Place] = dic.keys.first!
        let downloadTask: StorageDownloadTask = dic.values.first!
       
       
        //Download task 2
        let ref2 = globalReference.child("demoImages/5.png")
        let dic2 = PlaceServices.shared.downloadImage(reference: ref2)
        let data2: Data = dic2.keys.first!
        let downloadTask2: StorageDownloadTask = dic2.values.first!
      
        
        downloadTask.observe(.success) { snapshot in
            print("Download task 1 finished!")
            print("Number of elements in place array \(data.count)")
        }
        
        downloadTask2.observe(.success) { snapshot in
            print("Download task 2 finished!")
            print("Data count \(data2.count)")
            let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = docsPath.appendingPathComponent("test.png")
            do{
                try data2.write(to: imageURL)
            } catch {
                print (error)
            }
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
