//
//  SignUpViewController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 30/11/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class SignUpViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var logInButtonSignUp: UIButton!{
        didSet{
            logInButtonSignUp.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        }
    }
    
    @IBOutlet weak var welcomeLabel: UILabel!{
        didSet{
            welcomeLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.backgroundColor = .clear
            nameTextField.layer.borderColor = UIColor.white.cgColor
            nameTextField.layer.borderWidth = 2
            nameTextField.layer.cornerRadius = 25
            nameTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            nameTextField.leftView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height: nameTextField.frame.height))
            nameTextField.leftViewMode = .always
            nameTextField.textColor = UIColor.white
        }
    }
    @IBOutlet weak var surnameTextField: UITextField!{
        didSet{
            surnameTextField.backgroundColor = .clear
            surnameTextField.layer.borderColor = UIColor.white.cgColor
            surnameTextField.layer.borderWidth = 2
            surnameTextField.layer.cornerRadius = 25
            surnameTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            surnameTextField.leftView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height: surnameTextField.frame.height))
            surnameTextField.leftViewMode = .always
            surnameTextField.textColor = UIColor.white
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.backgroundColor = .clear
            emailTextField.layer.borderColor = UIColor.white.cgColor
            emailTextField.layer.borderWidth = 2
            emailTextField.layer.cornerRadius = 25
            emailTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            emailTextField.leftView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height: emailTextField.frame.height))
            emailTextField.leftViewMode = .always
            emailTextField.textColor = UIColor.white
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.backgroundColor = .clear
            passwordTextField.layer.borderColor = UIColor.white.cgColor
            passwordTextField.layer.borderWidth = 2
            passwordTextField.layer.cornerRadius = 25
            passwordTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            passwordTextField.leftView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height: passwordTextField.frame.height))
            passwordTextField.leftViewMode = .always
            passwordTextField.textColor = UIColor.white
        }
    }
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.layer.cornerRadius = 25
            signUpButton.backgroundColor = UIColor.white
            signUpButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)
        }
    }
   
    @IBOutlet weak var registrationDoneLabel: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    
    //Static properties
    static let notificationName = Notification.Name("messagesFromSignUp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //Listen for events related to Firebase Authentication 
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: SignUpViewController.notificationName, object: nil)
    }
    
    //Manage keyboard position
    deinit {
        NotificationCenter.default.removeObserver(self, name: SignUpViewController.notificationName, object: nil)
    }
   
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //Functions to manage keyboard overlap
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            print("Do nothing")
        default:
            print("Do scroll")
            scrollView.setContentOffset(CGPoint(x:0,y:100) , animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
          scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            nameTextField.becomeFirstResponder()
        }
        else if textField.tag == 1 {
            surnameTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 {
            emailTextField.resignFirstResponder()
        }
        else if textField.tag == 3 {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    @objc func onNotification(notification:Notification)
    {
        let notif: String = notification.userInfo?["result"] as! String
        if notif == "successfullSignUp" {
            let alertController = UIAlertController(title: "Registration done successfully", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        } else{
            let alertController = UIAlertController(title: notif, message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
    //Verify if fiels are empty
        if nameTextField.text == "" || surnameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Required fiels missing", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
    //Verify if email address has a valid form
        } else if !(emailTextField.text?.contains("@"))!{
            let alertController = UIAlertController(title: "Error", message: "Email address must have a valid form", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
    //Proceed to registration
        } else {
            PlaceServices.shared.createAccount(name: nameTextField.text!, surname: surnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    //Go back to Log in view
    @IBAction func backLogIn(_ sender: Any) {
        let vc = self.storyboard?.instantiateInitialViewController()
        self.present(vc!, animated: false, completion: nil)
    }
 
}
