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
    //Initialize Manager
    let manager = PlaceManager.shared
  
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
    
    
    
    //Function that downloads all images from a folder path in Firebase Storage
    func downloadDemoData(success:@escaping (_ arrayPlaces: [Place])->(),failure:@escaping (_ error:Error)->()){
        //Download json demo data
        let jsonRef = Storage.storage().reference(withPath: "demo/demo.json")
        jsonRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let placesArray = PlaceManager.shared.placesFrom(jsonData: _data)
                    //Download demo images
                    let numImages: Int = placesArray.count
                    for i in 0...numImages-1{
                        let imageRef = Storage.storage().reference(withPath: "demo/\(i).png")
                        imageRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                            if let _error = error{
                                print(_error)
                                failure(_error)
                            } else {
                                if let _data  = data {
                                    let myImage: Data = (UIImage(data: _data)?.pngData())!
                                    placesArray[i].image = myImage
                                    //Append places into manager
                                    self.manager.append(placesArray[i])
                                    success(placesArray)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //Function that downloads all images from a folder path in Firebase Storage
    /*func downloadUserData(success:@escaping (_ arrayPlaces: [Place])->(),failure:@escaping (_ error:Error)->()){
        //Download json user's data
        let jsonRef = Storage.storage().reference(withPath: "user/demo.json")
        jsonRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let placesArray = PlaceManager.shared.placesFrom(jsonData: _data)
                    //Download demo images
                    let numImages: Int = placesArray.count
                    for index in 0...numImages-1 {
                        let imageRef = Storage.storage().reference(withPath: "demo/\(index).png")
                        imageRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                            if let _error = error{
                                print(_error)
                                failure(_error)
                            } else {
                                if let _data  = data {
                                    let myImage: Data = (UIImage(data: _data)?.pngData())!
                                    placesArray[index].image = myImage
                                    //Append places into manager
                                    self.manager.append(placesArray[index])
                                    success(placesArray)
                                }
                            }
                        }
                    }
                }
            }
        }
    }*/

    func createAccount(name: String, surname: String, email: String, password: String) {
        //Save email and password in Authentication Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            var userInfo: String
                if error == nil {
                    userInfo = "successfullSignUp"
                    //Upload name and surname into Database
                    let userID = Auth.auth().currentUser!.uid
                    let ref: DatabaseReference! = Database.database().reference()
                    ref.child("users").child(userID).setValue(["name": name, "surname": surname])
                } else {
                    userInfo = (error?.localizedDescription)!
                }
            NotificationCenter.default.post(name: SignUpViewController.notificationName, object: nil, userInfo:["result": userInfo])
        }
    }
    
    func sendPasswordReset (email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            var userInfo: String
            if error != nil {
                userInfo = (error?.localizedDescription)!
            } else {
                userInfo = "successfullPasswordReset"
            }
             NotificationCenter.default.post(name: ForgottenPassController.notificationName, object: nil, userInfo:["result": userInfo])
        })
    }
    
    func logIn (email: String, password: String, success:@escaping (_ user: User)-> (),failure:@escaping (_ error:Error)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let _error = error{
                failure(_error)
            }else{
               //Retrive user's data
               let userID = Auth.auth().currentUser!.uid
               let ref: DatabaseReference! = Database.database().reference()
               ref.child("users").child(userID)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        
               let userDict = snapshot.value as! [String: Any]
               let name = userDict["name"] as! String
               let surname = userDict["surname"] as! String
               let user = User(name: name, surname: surname, userID: userID)
               self.manager.defineCurrentUser(user)
               success(user)
            })
           }
        }
    }
    
    
}
