//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by Marta Boteller on 15/10/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageSample: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set font for labels
        nameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)

    }
    
}
