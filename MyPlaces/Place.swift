//
//  Place.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller.  All rights reserved.
//

import MapKit

class Place: Decodable, Encodable {
    
    // We don't need to specify types when the compiler can infer them from context. That doesn't
    // mean id or name have no type or can have different types at different moments. No way. Both
    // are and will be String.
    var id = ""
    var type = PlaceType.generic
    var stringType = ""
    var name = ""
    var description = ""
    var location: CLLocationCoordinate2D!
    var image: Data?
    var stringImage = ""
    var discount_tourist = ""
    
    enum PlaceKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case image = "image"
        case latitude = "latitude"
        case longitude =  "longitude"
        case stringType = "stringType"
        case type = "type"
        case stringImage = "stringImage"
        case discount_tourist = "discount_tourist"
        
    }
    
    // We could have created a PlaceType.swift file for this enumeration or just put it in current
    // Place.swift file but outside the class (so, between those "import MapKit" and "clas Place
    // {"lines). However if we know we are only going to use it from our Place, it's probably
    // cleaner if the enumeration lives inside the class.
    enum PlaceType: String {
        case generic
        case touristic
    }
    
    // We need to learn more about initialization, but meanwhile we create some initializers.
    // This one has no information about name or description, so it creates an almost empty place.
    init() {
        self.id = UUID().uuidString
    }
   
    // This one creates a generic place with basic name and description information.
    init(name: String, description: String, image_in: Data?,stringImage: String) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
        self.stringImage = stringImage
    }
    
    // This one creates a generic or touristic place (based on parameter) with basic name and
    // description information. But wait a minute... shouldn't we create a PlaceTourist instance
    // if we wanted a touristic place? :)
    init(name: String, description: String, image_in: Data?, stringImage: String, type: PlaceType,location: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
        self.stringImage = stringImage
        self.type = type
        self.location = location
    }
    
    //This one considers an Id
    init(id: String, name: String, description: String, image_in: Data?, stringImage: String, type: PlaceType, location: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image_in
        self.stringImage = stringImage
        self.type = type
        self.location = location
    }
    
    required convenience init (from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let stringImage = try container.decode(String.self, forKey: .stringImage)
        let stringType = try container.decode(String.self, forKey: .stringType)
        let type = PlaceManager.shared.placeType(stringType)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //Decodes name of image into image to be able to initialize Place
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let image = docsPath.appendingPathComponent(stringImage)
        let data = UIImage(contentsOfFile: image.path)?.pngData()
        
        self.init(name: name, description: description, image_in: data, stringImage: stringImage,type: type, location: coordinate2D)
    }
    
    func encode(to: Encoder) throws {
        var container = to.container (keyedBy: PlaceKeys.self)
        try container.encode (name, forKey: .name)
        try container.encode (description, forKey: .description)
        //try container.encode (image, forKey: .stringImage)
        let stringType = PlaceManager.shared.typePlace(type)
        try container.encode (stringType, forKey: .stringType)
        try container.encode (stringImage, forKey: .stringImage)
        try container.encode (location?.latitude, forKey: .latitude)
        try container.encode (location?.longitude, forKey: .longitude)
    }
    
    
}

    






