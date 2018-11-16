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
    init(name:String, description: String, image_in: Data?, stringImage: String, discount_tourist:String, location: CLLocationCoordinate2D){
        super.init(name: name, description: description, image_in: image_in, stringImage: stringImage, type: .touristic,location: location)
        self.discount_tourist = discount_tourist
    }
    
    required convenience init (from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let stringImage = try container.decode(String.self, forKey: .stringImage)
        let discount_tourist = try container.decode (String.self, forKey: .discount_tourist)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //Decodes name of image into image to be able to initialize Place
        let image = UIImage(named: stringImage)
        let data = image?.pngData()
        
        self.init(name: name, description: description, image_in: data, stringImage: stringImage,discount_tourist: discount_tourist, location: coordinate2D)
    }
    
    override func encode(to: Encoder) throws {
        var container = to.container (keyedBy: PlaceKeys.self)
        try container.encode (name, forKey: .name)
        try container.encode (description, forKey: .description)
       // try container.encode (image, forKey: .image)
        try container.encode (stringImage, forKey: .stringImage)
        let stringType = PlaceManager.shared.typePlace(PlaceType.touristic)
        try container.encode (stringType, forKey: .stringType)
        try container.encode (discount_tourist, forKey: .discount_tourist)
        try container.encode (location?.latitude, forKey: .latitude)
        try container.encode (location?.longitude, forKey: .longitude)
    }
    
    
}
