//
//  PlaceAnnotation.swift
//  MyPlaces
//
//  Created by Marta Boteller on 16/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject {
    
    var annotationLocation: CLLocationCoordinate2D
    var annotationName = ""
    
    init(annotationName: String, annotationLocation:CLLocationCoordinate2D) {
        self.annotationName = annotationName
        self.annotationLocation = annotationLocation
    }

}

extension PlaceAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return annotationLocation
    }
    
}
