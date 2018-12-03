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
    static let notificationName = Notification.Name("messagesFromLogIn")
    var myImage: Data = Data()
    var user: User?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       self.hideKeyboardWhenTappedAround()
        
        //Listen for events related to Firebase Authentication
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AuthViewController.notificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PlaceServices.shared.downloadDemoData(success: {(myArray) in
            print("Success!")
        }) { (error) in
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        }
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
         NotificationCenter.default.removeObserver(self, name: AuthViewController.notificationName, object: nil)
    }
    
    @objc func onNotification(notification:Notification){
        let alertController = UIAlertController(title: notification.userInfo?["result"] as? String, message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func continueAsGuest(_ sender: Any) {
        self.performSegue(withIdentifier: "AccessAsGuest", sender: "")
    }
    @IBAction func retrivePassword(_ sender: Any) {
        performSegue(withIdentifier: "ForgottenPass", sender: "UserNamePassword")
    }
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: "UserNamePassword")
    }
    
    @IBAction func logInAction(_ sender: Any) {
        //performSegue(withIdentifier: "AccessApp", sender: "UserNamePassword")
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Required fiels missing", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        } else {
            PlaceServices.shared.logIn(email: emailTextField.text!, password: passwordTextField.text!,success: {
                (user) in
                //Access App
               self.performSegue(withIdentifier: "AccessApp", sender: "")
                
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
            /*let barViewControllers = segue.destination
                as? UITabBarController
            let nav = barViewControllers?.viewControllers![0] as! UINavigationController
            let destination = nav.topViewController as! TableViewController
            destination.user = sender as? User*/
        }
        if segue.identifier == "SignUp" {
        }
        if segue.identifier == "ForgottenPass" {
        }
        if segue.identifier == "AccessAsGuest" {
            
        }
    }

    
    
}
