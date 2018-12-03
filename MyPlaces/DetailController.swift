//
//  DetailController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    //Storyboard references
    @IBOutlet weak var typePlace: UILabel!{
        didSet{
            typePlace.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        }
    }
    @IBOutlet weak var iconPlace: UIImageView!
    @IBOutlet weak var namePlace: UILabel!{
        didSet{
            namePlace.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        }
    }
    @IBOutlet weak var descriptionPlace: UITextView!{
        didSet{
             descriptionPlace.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        }
    }
    @IBOutlet weak var detailTitleBar: UINavigationItem!{
        didSet{
            detailTitleBar.titleView =  UIImageView(image: UIImage(named: "appLogo.png"))
            detailTitleBar.titleView?.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var imgDetail: UIImageView!
   
    
    //Global variables
    var place: Place?
    var idPlace: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Fill elements with place info
        if let place = place {
        
            //Write down the place id
            idPlace = place.id
        
            //Fill view fields
            namePlace.text = place.name
            descriptionPlace.text = place.descriptionPlace
            typePlace.text = PlaceManager.shared.typePlace(place.type)
            imgDetail.image = UIImage(data: place.image!)
        
            //Associate icon with type of place
            if place.type == MyPlaces.Place.PlaceType.generic {
                iconPlace.image = UIImage(named: "g.png")
            }else{
                iconPlace.image = UIImage(named: "t.png")
            }
        }
    }
    
    //Restrict rotation
    override open var shouldAutorotate: Bool {
        return false
    }
        
    // MARK: - Actions done by icons on the tab bar
    
    @IBAction func Back(_ sender: Any) {
        //Nothing changed, just go back.
       // let vc = self.storyboard?.instantiateInitialViewController()
       // self.present(vc!, animated: false, completion: nil)
        dismiss(animated: true, completion: nil)    }

    @IBAction func editPlace(_ sender: Any) {
        //Allow to jump to EditController if displaying a place
        if !idPlace.isEmpty {
            let place = PlaceManager.shared.itemWithId(idPlace)
            performSegue(withIdentifier: "EditPlaceDetail", sender: place)
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlaceDetail" {
            if let dc = segue.destination as? EditController {
                dc.place = sender as? Place
            }
        }
    }

}
