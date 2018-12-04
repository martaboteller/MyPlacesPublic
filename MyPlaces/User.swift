//
//  User.swift
//  MyPlaces
//
//  Created by Marta Boteller on 2/12/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import Firebase


class User {
    
    var name = ""
    var surname = ""
    var userID =  ""
    
    init(name: String, surname: String, userID: String) {
        self.name = name
        self.surname = surname
        self.userID = userID
    }
    
    init(){
    }
    
   
}