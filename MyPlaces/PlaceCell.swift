//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by Marta Boteller on 15/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell{
    
    @IBOutlet weak var imageSampleView: UIView!{
        didSet{
            imageSampleView.layer.cornerRadius = 25
            imageSampleView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
            imageSampleView.layer.borderWidth = 1
            imageSampleView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
        nameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        }
        
    }
    @IBOutlet weak var imageSample: UIImageView!{
        didSet{
            imageSample.layer.cornerRadius = 25
            imageSample.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
          //  imageSample.alpha = 0.40
            
        }
    }
    
    
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
  
    
   
    
}
