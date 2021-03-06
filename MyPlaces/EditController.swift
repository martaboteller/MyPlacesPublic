//
//  EditController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 15/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//
import UIKit
import MapKit
import Firebase

class EditController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Storyboard references
    @IBOutlet weak var coordinatesLabel: UILabel!{
        didSet{
            coordinatesLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        }
    }
    @IBOutlet weak var textFieldCoord: UITextField!{
        didSet{
            textFieldCoord.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        }
    }
    @IBOutlet weak var placeName: UITextField!{
        didSet{
              placeName.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        }
    }
    @IBOutlet weak var placeDescription: UITextView!{
        didSet{
            placeDescription.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
            placeDescription.delegate?.textViewDidChange!(placeDescription)
            placeDescription.textContainer.maximumNumberOfLines = 7
            placeDescription.textContainer.lineBreakMode = .byWordWrapping
        }
    }
    
    @IBOutlet weak var editTitleBar: UINavigationItem!{
        didSet{
            editTitleBar.titleView =  UIImageView(image: UIImage(named: "appLogo.png"))
            editTitleBar.titleView?.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!{
        didSet{
            placeholderLabel.text = "Place description..."
            placeholderLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
            placeholderLabel.textColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var selectImg: UIButton!{
        didSet{
             selectImg.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveEdit: UIBarButtonItem!
    @IBOutlet weak var cancelEdit: UIBarButtonItem!
    @IBOutlet weak var removeEdit: UIBarButtonItem!

    //Global variables
    var place: Place?
    let logedUser = PlaceManager.shared.returnUserInfo()
    var reference: StorageReference = Storage.storage().reference()
    var pickerData: [String] = ["Generic Place", "Touristic Place"]
    var pickerImg = UIImagePickerController()
    var idPlace: String = ""
    var stringImage: String = ""
    var imageData: Data?
    var defaultDocsPath: URL?
    var defaultFileURL: URL?
    var defaultImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.hideKeyboardWhenTappedAround()
        
        //Connect data
        self.placeDescription.delegate = self
        self.picker.delegate = self
        self.pickerImg.delegate = self
        self.picker.dataSource = self
        
        // MARK: - Fill elements with place info
        
        if let place = place {
            //Write down the place id and image name if exists
            idPlace = place.id
            stringImage = place.stringImage
            
            //Fill editable fields
            insertPlace(place: place)
        } else{
            stringImage = "defaultImage.png"
        }
    }
  
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Functions that manage keyboad overlap
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            print("Do nothing")
        default:
            print("Do scroll")
            scrollView.setContentOffset(CGPoint(x:0,y:100) , animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
          scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            placeName.becomeFirstResponder()
        }
        else if textField.tag == 1 {
            placeDescription.becomeFirstResponder()
        }
        return true
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
        //stringImage = "ImageChanged"
    }
  
    //Remove edited place
    @IBAction func removeEdit(_ sender: Any) {
        if logedUser.userID == "" {
            let alertController = UIAlertController(title:"Only registered users can remove places", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        } else {
        //Don't need to remove new place
        if idPlace == "" {
            //Only go back to TableViewController, nothing has been changed
           self.dismiss(animated: true, completion: nil)
        } else {
            //Ask again for deletion
            let alertController = UIAlertController (title: "Are you sure you want to delete the current place?", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                { action in
                    //Delete place from manager
                    MyPlaces.PlaceManager.shared.remove(self.retrievePlace(image: (self.imgEdit!.image?.pngData())!))
                     
                     //Update json at Firebase Storage
                     let myPlacesArray:[Place] = PlaceManager.shared.returnSaved()
                     let jsonData = PlaceManager.shared.jsonFrom(places: myPlacesArray)
                    let jsonRef = self.reference.child("users/\(self.logedUser.userID)/user.json")
                     let uploadTask = PlaceServices.shared.uploadData(reference: jsonRef, dataToUpload: jsonData!, metadataContentType: "json")
                     print (uploadTask.debugDescription)
                     //Delete image from Firebase Storage
                    let imgRef = self.reference.child("users/\(self.logedUser.userID)/\(self.stringImage)")
                     
                     //Delete image from Firebase Storage
                    PlaceServices.shared.deleteData(reference: imgRef, fileName: self.stringImage)
                     
                     //Go back to TableViewController view
                     self.performSegue(withIdentifier: "ShowTableViewFromEdit", sender: nil)
                }
            ))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler:
                { action in
                  self.performSegue(withIdentifier: "ShowTableViewFromEdit", sender: nil)
                }
            ))
            self.present(alertController, animated: true)
            }
        }
    }
    
    //Save changes on edited place
    @IBAction func saveEdit(_ sender: Any) {
        var myPlacesArray: [Place] = [Place]()
        if logedUser.userID == ""{
            let alertController = UIAlertController(title:"Only registered users can save places", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        }else{
        //Save image at FileManager and update its name
        //Set a name for the image (0.png, 1.png, 2.png..)
        myPlacesArray = PlaceManager.shared.returnSaved()
        let numPl:Int = myPlacesArray.count
        if stringImage == "defaultImage.png"{
            stringImage = ("\(numPl).png")
        }
        //Upload image (new or changed) into Firebase Storage
        let imgRef = reference.child("users/\(logedUser.userID)/\(stringImage)")
        //Reduce Image size
            let reducedImage = imgEdit.image!.resizedTo1MB()
        let imgData = reducedImage?.pngData()
        let uploadTaskImg = PlaceServices.shared.uploadData(reference: imgRef, dataToUpload: imgData!, metadataContentType: "image")
        print (uploadTaskImg.debugDescription)
        
        let place: Place = retrievePlace(image: (imgEdit!.image?.pngData())!)
        place.stringImage = stringImage //Would only be necessary if changed
        
        //Verify if it is a new place
        //Retreive places after update
        //placeArray = PlaceManager.shared.returnSaved()
        var str: String = "It's a new place"
        if myPlacesArray.count > 0 {
            for i in 0...myPlacesArray.count-1 {
                if place.id == myPlacesArray[i].id {
                    str = ""
                }
            }
        }
        //Append or Update place to save
        if str == "It's a new place" {
            PlaceManager.shared.append(place)
        } else {
            PlaceManager.shared.update(place)
        }
        //Update json file at FileManager
        myPlacesArray = PlaceManager.shared.returnSaved()
        //Save json at Firebase Storage
        let jsonData = PlaceManager.shared.jsonFrom(places: myPlacesArray)
        let jsonRef = reference.child("users/\(logedUser.userID)/user.json")
        let uploadTaskJson = PlaceServices.shared.uploadData(reference: jsonRef, dataToUpload: jsonData!, metadataContentType: "json")
        print (uploadTaskJson.debugDescription)
        //Go back to previous view
        performSegue(withIdentifier: "UnwindGoDetail", sender: place)
        }
    }
    
    //Go back to previous screen
    @IBAction func cancelEdit(_ sender: Any) {
        performSegue(withIdentifier: "ShowTableViewFromEdit", sender: nil)
    }
    
    @IBAction func goFindCoordinates(_ sender: Any) {
        let place: Place = retrievePlace(image: (imgEdit!.image?.pngData()))
        place.stringImage += "LookingForCoordinates"
        performSegue(withIdentifier: "PickUpCoordinates", sender: place)
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
    
    //Function that limits the number of characters inside place name textfield
    func maxLength (textFieldName: UITextField, max: Int){
        let length = textFieldName.text?.count
        let metin = textFieldName.text
        
        if (length! > max) {
            let index = metin?.index((metin?.startIndex)!, offsetBy: max)
            textFieldName.text = String((textFieldName.text?.prefix((index?.encodedOffset)!))!)
        }
    }
    
    //Function that fills editable fields with the place info
    //If don't have an id (don't have a place) do nothing
    func insertPlace (place: Place){
        if !place.id.isEmpty {
            placeholderLabel.isHidden = true
            placeName.text = place.name
            placeDescription.text = place.descriptionPlace
            imgEdit.image = UIImage(data: place.image!)
            textFieldCoord.text = PlaceManager.shared.coordToString(latitude: place.location.latitude, longitude: place.location.longitude)
            
            //Display first element of the picker depending on the type of place
            if place.type == MyPlaces.Place.PlaceType.generic {
                pickerData = ["Generic Place", "Touristic Place",]
            } else {
                pickerData = ["Touristic Place", "Generic Place"]
            }
        }
    }
    
    //Constructs place from info displayed at EditController view
    func retrievePlace (image: Data?) -> Place {
        let selectedValue: String = pickerData[picker.selectedRow(inComponent: 0)]
        let typeOfPlace: MyPlaces.Place.PlaceType = PlaceManager.shared.placeType(selectedValue)
        let coord:CLLocationCoordinate2D = PlaceManager.shared.stringToCoord(stringOfCoords: textFieldCoord.text!)
        
        if idPlace == "" {
             place = Place(name: placeName.text!, descriptionPlace: placeDescription.text!,image_in: image, stringImage: stringImage, type: typeOfPlace, location: coord)
        } else {
             place = Place(id: idPlace,name: placeName.text!, descriptionPlace: placeDescription.text!,image_in: image, stringImage: stringImage, type: typeOfPlace, location: coord)
        }
        return place!
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindGoDetail" {
            if let dc = segue.destination as? DetailController {
                dc.place = sender as? Place
            }
        }
        if segue.identifier == "ShowTableViewFromEdit" {
            /* let tvc = segue.destination as? TableViewController
            tvc!.places = sender as? [Place]*/
        }
        //Concatenate identifining words "LookingForCoordinates" to place.stringImage
        //Will remove them at MapViewController before sending place back
        if segue.identifier == "PickUpCoordinates"{
           // let placeToSend: Place = retrievePlace(image: (imgEdit!.image?.pngData())!)
            if let dc = segue.destination as? MapViewController {
                dc.place = sender as? Place
            }
        }
    }
}

extension EditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Function that controlls the selection of images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            pickerImg.dismiss(animated: true, completion: nil)
            imgEdit.image = image
        }
    }
}

extension EditController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
}

extension UIImage {
    //Resize image in order to upload it at Firebase Storage
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    //Limit size to 1MB
    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        return resizingImage
    }
}

