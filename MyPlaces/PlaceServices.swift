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
    
    //Function that uploads data into Firebase Storage
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
                print ("An error occurred \(error)")
            } else {
                print("Data uploaded!")
            }
        }
        return uploadTask
    }
    
    //Function that deletes data from Firebase Storage
    func deleteData (reference: StorageReference, fileName: String) {
        // Delete data (image or json)
         reference.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //Function that downloads demo places from Firebase Storage
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
                                     success(placesArray)
                                }
                            }
                        }
                    }
                   
                }
            }
        }
    }
    
    //Function that downloads user's places from Firebase Storage
    func downloadUserData(userID: String, success:@escaping (_ arrayPlaces: [Place])->(),failure:@escaping (_ error:Error)->()){
        //Download json user's data
        let jsonRef = Storage.storage().reference(withPath: "users/\(userID)/user.json")
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
                        let imageRef2 = Storage.storage().reference(withPath: "users/\(userID)/\(index).png")
                        print(imageRef2)
                        imageRef2.getData(maxSize: (1 * 1024 * 1024)) { (imgData, errorImg) in
                            if let _errorImg = errorImg{
                                print(_errorImg)
                                print("I am having an error")
                                failure(_errorImg)
                            } else {
                                print("I have found images")
                                if let _imgData  = imgData {
                                    print("The images are data")
                                    let myImage2: Data = (UIImage(data: _imgData)?.pngData())!
                                    print(myImage2.debugDescription)
                                    placesArray[index].image = myImage2
                                    success(placesArray)
                                }
                            } 
                        }
                    }
                  
                }
            }
        }
    }

    //Function that creates a new user
    //and saves it on Database/Athentication cloud
    func createAccount(name: String, surname: String, email: String, password: String) {
        //Save email and password
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            var userInfo: String
                if error == nil {
                    userInfo = "successfullSignUp"
                    //Save name, surname and userID
                    let userID = Auth.auth().currentUser!.uid
                    let ref: DatabaseReference! = Database.database().reference()
                    ref.child("users").child(userID).setValue(["name": name, "surname": surname])
                } else {
                    userInfo = (error?.localizedDescription)!
                }
            NotificationCenter.default.post(name: SignUpViewController.notificationName, object: nil, userInfo:["result": userInfo])
        }
    }
    
    //Function that sends a reset password email to the user
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
    
    //Function that authenticates user with an email/password
    //Connects to Database and provides the user's data profile
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
