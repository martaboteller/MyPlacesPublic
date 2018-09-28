//
//  Place.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller.  All rights reserved.
//

import Foundation
import MapKit //para encontrar CLlocationCoordinate2D de propiedad location

class Place {
    
    //types
    enum PlacesTypes{
        case GenericPlace
        case TouristicPlace
    }
    
    //variables
    var id:String = ""
    var type:PlacesTypes = .GenericPlace
    var name:String = ""
    var description:String=""
    var location:CLLocationCoordinate2D!
    var image:Data?=nil
    
    //constructors
    init(){self.id = UUID().uuidString}
    init(name:String,description:String,image_in:Data?){
        self.id = UUID().uuidString
        self.name=name
        self.description=description
        self.image=image_in
      
    }
    init(type:PlacesTypes,name:String,description:String,image_in:Data?){
        self.id = UUID().uuidString
        self.type=type
        self.name=name
        self.description=description
        self.image=image_in
    }
}

class PlaceTourist:Place {
   
    var discount_tourist:String=""
    
    override init()
    {
        super.init()
        type = .TouristicPlace
    }
    init(name:String,description:String,discount_tourist:String,image_in:Data?){
        super.init(type:.TouristicPlace,name:name,description:description,image_in:image_in)
        self.discount_tourist=discount_tourist
    }
}


class ManagerPlaces {
    
    //make singleton class
    static let shared = ManagerPlaces()
    
    var places:[Place] = []
    
    init(){}
    
    //funciton to add a place
    func append(_ value:Place){
        places.append(value)
    }
    
    //function to count stored places
    func GetCount()->Int{
        return places.count
    }
    
    //function to get place by position on array
    func GetItemAtPosition(position:Int)-> Place{
        return places[position]
    }
    
    //function to get a place by id
    func GetItemById(id:String)-> Place{
       return  places.filter{$0.id == id }[0]
    }
 
    //function to remove a place by id
    func remove(_ value:Place){
        places = places.filter { $0 !== value}
    }
        
}
    

    






