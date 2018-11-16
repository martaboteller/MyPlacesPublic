//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show logo instead of application name
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "appLogo.png"))
        self.navigationItem.titleView?.tintColor = UIColor.white
    }
    
    //Restrict rotation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
  
}

