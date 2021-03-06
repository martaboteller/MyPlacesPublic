//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 22/9/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import Firebase
import DropDown


// Do you see those MARK lines there in the code? They do nothing (of course, they are comments
// after all). But that special syntax let you define some nice sections in the header. Have a look at the bar at the top
// of this code file. You should see something like...
// MyPlaces > MyPlaces > FirstViewController.swift > No Selection
// Click on the last element and you will get a drop down list from which you can navigate to any method in current file.
// Those MARK lines let you specify some sections to group related methods.

// TableViewController is subclass of UITableViewController.
// UITableViewController is subclass of UIViewController.
// UITableViewController adopts two protocols: UITableViewDelegate and UITableViewDataSource.
// So, by being a subclass of UITableViewController, our TableViewController:
//     1) is also a subclass of UIViewController,
//     2) automatically adopts both UITableViewDelegate and UITableViewDataSource protocols.
class TableViewController: UITableViewController {
    
    @IBOutlet weak var menuIcon: UIBarButtonItem!
    
    //Global variables
    var dropDown = DropDown()
    let logedUser = PlaceManager.shared.returnUserInfo()
    let manager = PlaceManager.shared
    var places: [Place]?
    
    override func viewDidLoad() {
       
         super.viewDidLoad()
        
        // Never forget to set delegate and dataSource for our UITableView!
        let view = self.view as! UITableView
        view.delegate = self
        view.dataSource = self
        
        if let places = places {
            //Append places received from previous view
            for pl in places {
                self.manager.append(pl)
            }
        }
       
        // Fill and format dropdown menu with a custom cell (MyCell)
        dropDown.anchorView = menuIcon
        dropDown.dataSource = [logedUser.name, "Log Out"]
        dropDown.width = 130
        dropDown.textFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)!
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:45)
        dropDown.cellNib = UINib (nibName: "MyCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
            if index == 0{
                cell.logoImageView.image = UIImage(named: "user")
            } else {
                cell.logoImageView.image = UIImage(named: "out")
            }
        }
        
        //Show logo instead of application name
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "appLogo.png"))
        self.navigationItem.titleView?.tintColor = UIColor.white
       
    }
  
    
    //Dropdown activated when menu icon is tapped
    @IBAction func displayDropDown(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 1 {
                do {
                    try Auth.auth().signOut()
                    let places = PlaceManager.shared.returnSaved()
                    for p in places {
                        PlaceManager.shared.remove(p)
                        //remove places before login out
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController")
                self.present(vc, animated: false, completion: nil)
            }
        }
        
    }
    
    
    //Restrict rotation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    // MARK: - Methods declared in UITableViewDataSource
    
    // We never call this method. iOS will call it when it needs some information. And this method is our chance to inform iOS
    // about how many sections the table must show. This is because tables can show information in different sections. For
    // instance, at some point we may want to show a first section with all generic places and a second section with all
    // touristic places. But for now we're showing all places together. So, one section.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // We never call this method. iOS will call it when it needs some information. And this method is our chance to inform iOS
    // about how many rows the table must show for each section. As we only have one section, it will have as many rows
    // as places in our PlaceManager.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceManager.shared.count()
    }
    
    // We never call this method. iOS will call it when it needs some information. And this method is our chance to inform iOS
    // about what cell it has to show for a given index. We build that cell and then return it.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Given an index, we ask our PlaceManager for the place at that index.
        let place = PlaceManager.shared.itemAt(position: indexPath.item)!
        
        // We ask our table for a reusable cell. Then we set its basic details and return it.
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.nameLabel.text = place.name
        cell.descriptionLabel.text = place.descriptionPlace
        let imageIcon: UIImage = UIImage(data:   ((PlaceManager.shared.itemAt(position: indexPath.row))?.image)!)!
        cell.imageSample.image = imageIcon
        
        return cell
        
    }
    
    // MARK: - Methods declared in UITableViewDelegate
    
    // We never call this method. iOS will call it when it wants to tell us that a row has been
    // selected. We can just ignore that (and add no code in this method) if we just don't care when the user selects a row.
    // But if we want to do something (like navigate to a different screen), we need to add the code for that action in this
    // method.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // First we find out what place the user has selected.
        let place = PlaceManager.shared.itemAt(position: indexPath.row)
        // Then we ask the app to take the "ShowPlaceDetail" road (segue) to a different screen.
        performSegue(withIdentifier: "ShowPlaceDetail", sender: place)
    }
    
    // We never call this method. iOS will call it when it needs some information. And this method
    // is our chance to inform iOS about how tall our cells are. iOS needs this information to
    // perform some calculations about scrolling sizes, etc. Do not worry too much about the value
    // you return: anything not too far from the real height value of your cells will be OK.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - Navigation
    
    // See where we said... we ask the app to take the "ShowPlaceDetail" road (segue) to a different
    // screen? OK. When we ask the app to take any road (performSegue), iOS will call this method
    // in case any preparation is required. In this case, we're only checking which road to take
    // and, if it is the "ShowPlaceDetail" one, we send the place object to the destination screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlaceDetail" {
            if let dc = segue.destination as? DetailController {
                dc.place = sender as? Place
            }
        }
    }
   
}


