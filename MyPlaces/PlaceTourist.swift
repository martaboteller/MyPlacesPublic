//
//  PlaceTourist.swift
//  MyPlaces
//
//  Created by Marta Boteller on 14/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//
import UIKit
import MapKit

// PlaceTourist is subclass of Place.
// So, Place is PlaceTourist's superclass.
// Please note Place has no superclass.
class PlaceTourist : Place {
    
    // Please read more about initializers at:
    // https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    override init() {
        super.init()
        self.type = .touristic
         
    }
    
   // Please read more about initializers at:
   // https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    init(name:String, descriptionPlace: String, image_in: Data?, stringImage: String, discount_tourist:String, location: CLLocationCoordinate2D){
        super.init(name: name, descriptionPlace: descriptionPlace, image_in: image_in, stringImage: stringImage, type: .touristic,location: location)
        self.discount_tourist = discount_tourist
    }
    
    //Explains how to decode PlaceTourist
    //Breaking PlaceTourist into elements readable by Json
    required convenience init (from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let descriptionPlace = try container.decode(String.self, forKey: .descriptionPlace)
        let discount_tourist = try container.decode (String.self, forKey: .discount_tourist)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let stringImage = try container.decode(String.self, forKey: .stringImage)
        
        //We only need to store stringImage at Json
        //Will retrieve imageData from proper path
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let image = docsPath.appendingPathComponent(stringImage)
        let data = UIImage(contentsOfFile: image.path)?.pngData()
        
        self.init(name: name, descriptionPlace: descriptionPlace, image_in: data, stringImage: stringImage,discount_tourist: discount_tourist, location: coordinate2D)
    }
    
    //Explains how to encode Place
    //Will reconstruct image using it's name (stringImage)
    override func encode(to: Encoder) throws {
        var container = to.container (keyedBy: PlaceKeys.self)
        try container.encode (name, forKey: .name)
        try container.encode (descriptionPlace, forKey: .descriptionPlace)
        try container.encode (stringImage, forKey: .stringImage)
        try container.encode (discount_tourist, forKey: .discount_tourist)
        try container.encode (location?.latitude, forKey: .latitude)
        try container.encode (location?.longitude, forKey: .longitude)
        
        //Encode variable stringType not type
        let stringType = PlaceManager.shared.typePlace(PlaceType.touristic)
        try container.encode (stringType, forKey: .stringType)
    }
    
}
