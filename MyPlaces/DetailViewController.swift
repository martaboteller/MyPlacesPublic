//
//  DetailViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 25/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var imageDetailView: UIImageView!
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        if let place = place {
           print("Hello")
            placeName.text = place.name
            imageDetailView.image = UIImage (data: place.image!)
        }
    }
    

   

}
