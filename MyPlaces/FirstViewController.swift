//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    //create singleton instance of ManagerPlaces
    let manager = ManagerPlaces.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        //number of manager elements
        return manager.GetCount()
    }
    
    override func numberOfSections(in tableView:UITableView)->Int{
        //indicate subsections - there are no subsections in our case
        return 1;
    }
   
    override func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath){
        //detect element pulsation - getting the index path of selected row
        let whatIpressed: String = manager.GetItemAtPosition(position: indexPath.row).name
       
        //print name
        print(whatIpressed)
    }
    
    override func tableView(_ tableView:UITableView,heightForRowAt indexPath:IndexPath)-> CGFloat{
        //return the height of the row
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = UITableViewCell()
        
        let wt: CGFloat = tableView.bounds.size.width
        
        
        // Add subviews to cell
        // UILabel and UIImageView
        
        var label: UILabel
        label = UILabel(frame: CGRect(x:80,y:30,width:wt,height:14))
        let fuente: UIFont = UIFont(name:"TimesNewRomanPSMT", size: 18)!
        label.font = fuente
        label.numberOfLines = 4
        label.text = manager.GetItemAtPosition(position: indexPath.row).name //get manager name
        label.sizeToFit()
        cell.contentView.addSubview(label)
        
        //get manager images
        let imageIcon: UIImageView = UIImageView (image: UIImage(data: (manager.GetItemAtPosition(position: indexPath.row).image!)))
         imageIcon.frame = CGRect(x:10, y:20, width:50, height:50)
        cell.contentView.addSubview(imageIcon)
        
        return cell
    }

}

