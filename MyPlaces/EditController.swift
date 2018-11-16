//
//  EditController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 15/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//
import UIKit
import MapKit

class EditController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
   
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDescription: UITextView!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var editTitleBar: UINavigationItem!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var selectImg: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveEdit: UIBarButtonItem!
    @IBOutlet weak var cancelEdit: UIBarButtonItem!
    @IBOutlet weak var removeEdit: UIBarButtonItem!

    //Global variables
    var place: Place?
    var pickerData: [String] = ["Generic Place", "Touristic Place"]
    var pickerImg = UIImagePickerController()
    var idPlace: String = ""
    var stringImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change the application title for a logo
        editTitleBar.titleView =  UIImageView(image: UIImage(named: "appLogo.png"))
        editTitleBar.titleView?.tintColor = UIColor.white
        
        //Format name and description texts
        placeName.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        placeDescription.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        
        //Format placeholder for place description
        placeholderLabel.text = "Place description..."
        placeholderLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        placeholderLabel.textColor = UIColor.lightGray
        placeDescription.delegate?.textViewDidChange!(placeDescription)
        placeDescription.textContainer.maximumNumberOfLines = 7
        placeDescription.textContainer.lineBreakMode = .byWordWrapping
        
        //Format button that selects new image
        selectImg.tintColor = UIColor.white
        //selectImg.titleLabel?.text = "..."
        //selectImg.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 50)
        
        //Connect data
        self.placeDescription.delegate = self
        self.picker.delegate = self
        self.pickerImg.delegate = self
        self.picker.dataSource = self
        
        // MARK: - Fill elements with place info
        
        if let place = place {
            
            //Write down the place id and image name
            idPlace = place.id
            stringImage = place.stringImage
            
            //Fill editable fields
            insertPlace(place: place)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Restrict rotation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Actions done by icons on the tab bar and view elements
    
    //Limit number of characters in placeName textfield
    @IBAction func textField_textChange(_ sender: UITextField) {
        maxLength(textFieldName: placeName , max: 38)
    }
    
    //Select image from library
    @IBAction func findImage(_ sender: Any) {
        pickerImg.sourceType = .photoLibrary
        pickerImg.allowsEditing = true
        present(pickerImg, animated: true, completion: nil)
    }
  
    //Remove edited place
    @IBAction func removeEdit(_ sender: Any) {
    //Don't need to remove new place
        if idPlace == "" {
            dismiss(animated: true, completion: nil)
        //Update existing place
        } else {
            //Path and file
            let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let userdataFile = docsPath.appendingPathComponent("userPlaces.json")
            
            //Retreive place
            let imageData: Data = imgEdit.image!.pngData()!
            let selectedValue: String = pickerData[picker.selectedRow(inComponent: 0)]
            let typeOfPlace: MyPlaces.Place.PlaceType = PlaceManager.shared.placeType(selectedValue)
            let placeToRemove: Place? = Place(id: idPlace,name: placeName.text!, description: placeDescription.text!,image_in: imageData, stringImage: stringImage, type: typeOfPlace, location: CLLocationCoordinate2D(latitude: 42.4, longitude: 2.3))
                
            MyPlaces.PlaceManager.shared.remove(placeToRemove!)
            let vc = self.storyboard?.instantiateInitialViewController()
            self.present(vc!, animated: false, completion: nil)
            
             //Write all places into file in FileManager
            let myPlacesArray:[Place] = PlaceManager.shared.returnSaved()
            if PlaceManager.shared.writeToJson(fileName: userdataFile, places: myPlacesArray){
                print("User's data correctly saved into file")
            }else{
                print("Error saving user's data")
            }
            
            //Delete image from file
            if PlaceManager.shared.deleteImage(imageName: stringImage){
                print ("Image " + stringImage + " deleted from file")
            }else{
                print("Error deleting image from file")
            }
        }
    }
    
    //Save changes on edited place
    @IBAction func saveEdit(_ sender: Any) {
   
        //Path and file
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let userdataFile = docsPath.appendingPathComponent("userPlaces.json")
        
        //Construct place
        let imageData: Data = imgEdit.image!.pngData()!
        let selectedValue: String = pickerData[picker.selectedRow(inComponent: 0)]
        let typeOfPlace: MyPlaces.Place.PlaceType = PlaceManager.shared.placeType(selectedValue)
            
        //Saving a new place
        //Place constructor without id
        if idPlace == "" {
            
            //Separately, save image into file and return it's name
            let imageName: String = PlaceManager.shared.saveImage(image:imageData)
            
            //Create new place
            let editedPlace: Place? = Place(name: placeName.text!, description: placeDescription.text!, image_in: imageData, stringImage:imageName,type: typeOfPlace,location: CLLocationCoordinate2D(latitude: 42.4, longitude: 2.3)  )
            
            //Append it to manager
            PlaceManager.shared.append(editedPlace!)
            let myPlacesArray:[Place] = PlaceManager.shared.returnSaved()
          
            //Write all places into file in FileManager
            if PlaceManager.shared.writeToJson(fileName: userdataFile, places: myPlacesArray){
                print("User's data correctly saved into file")
            }else{
                print("Error saving user's data")
            }
            
            performSegue(withIdentifier: "UnwindGoDetail", sender: editedPlace)
            
        //Update existing place
        //Place constructor with id
        } else {
            let editedPlace: Place? = Place(id: idPlace,name: placeName.text!, description: placeDescription.text!,image_in: imageData, stringImage: stringImage, type: typeOfPlace, location:CLLocationCoordinate2D(latitude: 42.4, longitude: 2.3))
                
            PlaceManager.shared.update(editedPlace!)
            
            //Update changes on json
            let myPlacesArray:[Place] = PlaceManager.shared.returnSaved()
            
            //Write all places into file in FileManager
            if PlaceManager.shared.writeToJson(fileName: userdataFile, places: myPlacesArray){
                print("User's data correctly saved into file")
            }else{
                print("Error saving user's data")
            }
            performSegue(withIdentifier: "UnwindGoDetail", sender: editedPlace)
        }
    }
    
    //Go back to previous screen
    @IBAction func cancelEdit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    //Function that hides the placeholder label when user starts editing
    func textViewDidChange(_ textView: UITextView) {
        if !placeDescription.text.isEmpty {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
    
    //Function that returns the number of columns of picker place type
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Function that returns the number of rows of the picker place type
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    //Function that returns the row and column (component) of the selected picker type place
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Function that returns an edited pickerLabel for the type of place
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerData [row]
        return pickerLabel!
    }
    
    //Function that limits the number of characters inside place name textfield
    func maxLength (textFieldName: UITextField, max: Int){
        let length = textFieldName.text?.count
        let metin = textFieldName.text
        
        if (length! > max) {
            let index = metin?.index((metin?.startIndex)!, offsetBy: max)
            textFieldName.text = String((textFieldName.text?.prefix((index?.encodedOffset)!))!)
        }
    }
    
    //Function that fills the editable fields with the place info
    //If don't have an id (don't have a place) do nothing
    func insertPlace (place: Place){
        if !place.id.isEmpty {
            placeholderLabel.isHidden = true
            placeName.text = place.name
            placeDescription.text = place.description
            imgEdit.image = UIImage(data: place.image!)
            //display first element of the picker depending on the type of place
            if place.type == MyPlaces.Place.PlaceType.generic {
                pickerData = ["Generic Place", "Touristic Place",]
            } else {
                pickerData = ["Touristic Place", "Generic Place"]
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindGoDetail" {
            if let dc = segue.destination as? DetailController {
                dc.place = sender as? Place
            }
        }
    }
    
    
}

extension EditController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            pickerImg.dismiss(animated: true, completion: nil)
            imgEdit.image = image
        }
    }
}

