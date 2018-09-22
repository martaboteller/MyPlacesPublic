//
//  Place.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import Foundation
import MapKit //para encontrar CLlocationCoordinate2D de propiedad location

class Place {
    
    enum PlacesTypes{
        case GenericPlace
        case TouristicPlace
    }
    
    //variables
    var id:String = ""
    var type:PlacesTypes = .GenericPlace
    var name:String = ""
    var location:CLLocationCoordinate2D!
    var image:Data?=nil
    
    //constructores
    init(){self.id = UUID().uuidString}
    init(name:String,description:String,image_in:Data?){
         self.id = UUID().uuidString
    }
    init(type:PlacesTypes,name:String,description:String,image_in:Data?){
        self.id = UUID().uuidString
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
    var ManagerPlaces: [Place]
    init(){}
    
    //para añadir un place
    func append(_value:Place){}
    //para saber el num de place
    func GetCount()->Int{}
    //para obtener un place por posición
    func GetItemAtPosition(position:Int)-> Place{}
    //para obtener un place por id
    func GetItemById(id:String)-> Place{}
    //para borrar un elemento por id
    func remove(_value:Place){}
    
}





