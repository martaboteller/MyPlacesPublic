//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //Storyboard references
    @IBOutlet weak var mapViewBottonItem: UIBarButtonItem!
    @IBOutlet weak var mapViewSavePlaceItem: UIBarButtonItem!
    @IBOutlet weak var mapViewBottomBar: UIToolbar!
    @IBOutlet weak var mapViewNavigationTitle: UINavigationItem!
    @IBOutlet weak var mapViewNavigationBar: UINavigationBar!
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    //General variables
    var marker = GMSMarker()
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Show logo instead of application name
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "appLogo.png"))
        self.navigationItem.titleView?.tintColor = UIColor.white
        
        //Center map with initial position
        let camera = GMSCameraPosition.camera(withLatitude: 41.385463, longitude: 2.166953, zoom: 10.0)
        mapView.camera = camera
       
        //Retrieve array of Places
        let arrayOfPlaces: [Place] = PlaceManager.shared.returnSaved()
       
        //Display all places
        for pl in arrayOfPlaces {
            marker = GMSMarker()
            marker.position = pl.coordinate
            marker.title = pl.title
            marker.map = mapView
        }
        
        //If coming from EditController by segue "PickUpCoordinates":
        //Show Navigation bar and toolbar
        //Display logo instead of application name at Navigation bar
        if let place = place {
            if place.stringImage.range(of:"LookingForCoordinates") != nil {
               mapViewNavigationBar.isHidden = false
               mapViewNavigationTitle.titleView =  UIImageView(image: UIImage(named: "appLogo.png"))
               mapViewNavigationTitle.titleView?.tintColor = UIColor.white
               mapViewBottomBar.isHidden = false
            }
        }
    }
    
    //Navigate from MapViewController to EditController
    //Delete last part of place.stringImage used to detect transition from EditController
    //Pass new location coordinates inside of place.location
    @IBAction func mapToEditController(_ sender: Any) {
        place?.stringImage = (place?.stringImage.replacingOccurrences(of: "LookingForCoordinates", with: ""))!
         performSegue(withIdentifier: "ReturnCoordinates", sender: place)
    }
    
    //Delegate function that detects map being tapped
    //If being tapped when coming from EditController save coordinates into place
    //Display marker at tapped position
    //Enable "save place" item at bottom bar
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if place?.stringImage.range(of: "LookingForCoordinates") != nil {
            marker.position = coordinate
            marker.title = "Lat: " + String(Double(round(1000*coordinate.latitude)/1000)) + "  " + "Long: " + String(Double(round(1000*coordinate.longitude)/1000))
            mapView.selectedMarker = marker
            marker.icon = GMSMarker.markerImage(with: UIColor.darkGray)
            marker.map = mapView
            mapViewBottonItem.isEnabled = true
            place?.location = coordinate
        }
    }
    
    //Prepare segue from MapViewController to EditController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReturnCoordinates" {
            if let dc = segue.destination as? EditController {
                dc.place = sender as? Place
            }
        }
    }
    
     //Restrict rotation
    override open var shouldAutorotate: Bool {
        return false
    }
    
}


