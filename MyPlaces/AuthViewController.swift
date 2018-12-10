//
//  AuthViewController.swift
//  MyPlaces
//
//  Created by Laura Llunell on 24/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import MapKit
import Firebase

class AuthViewController: UIViewController {
   
    @IBOutlet weak var forgotPasswordButton: UIButton!{
        didSet{
            forgotPasswordButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        }
    }
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        }
    }
    @IBOutlet weak var guestButton: UIButton!{
        didSet{
            guestButton.layer.cornerRadius = 25
            guestButton.layer.borderColor = UIColor.white.cgColor
            guestButton.layer.borderWidth = 2
            guestButton.backgroundColor = .clear
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        }
    }
   
    @IBOutlet weak var logIn: UIButton!
    
    //Static properties
    static let msgFromLogIn = Notification.Name("messagesFromLogIn")
    
    var user: User?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       self.hideKeyboardWhenTappedAround()
        
        //Listen for events related to Firebase Authentication
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AuthViewController.msgFromLogIn, object: nil)
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: AuthViewController.msgFromLogIn, object: nil)
    }
    
    @objc func onNotification(notification:Notification){
        let alertController = UIAlertController(title: notification.userInfo?["result"] as? String, message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true)
    }
    
    //Log in as Guest, will load demo data into TableViewController
    @IBAction func continueAsGuest(_ sender: Any) {
        PlaceServices.shared.downloadDemoData(success: {(myArray) in
            self.performSegue(withIdentifier: "AccessApp", sender: myArray)
         }) { (error) in
         let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true)
         }
    }
    //Go to ForgottenPassViewController view and make the user type an email
    @IBAction func retrivePassword(_ sender: Any) {
        performSegue(withIdentifier: "ForgottenPass", sender: "")
    }
    
    //Go to SignUpViewController view and allow user to create an account
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: "")
    }
    
    //Log in (authenticate) and access the app with the user's profile/data
    @IBAction func logInAction(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Required fiels missing", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        } else {
            PlaceServices.shared.logIn(email: emailTextField.text!, password: passwordTextField.text!,success: {
                (user) in
                //Access App
                PlaceServices.shared.downloadUserData(userID:user.userID,success: {(myArray) in
                    self.performSegue(withIdentifier: "AccessApp", sender: myArray)
                }) { (error) in
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true)
                }
            }) { (error) in
                let alertController = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "AccessApp" {
            if let tbc = segue.destination as? UITabBarController {
                let nc = tbc.viewControllers![0] as! UINavigationController
                let dc = nc.topViewController as! TableViewController
                dc.places = sender as? [Place]
            }
        }
    }
    
    
}
