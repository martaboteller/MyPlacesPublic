//
//  ForgottenPassController.swift
//  MyPlaces
//
//  Created by Marta Boteller on 1/12/18.
//  Copyright © 2018 Marta Boteller. All rights reserved.
//

import UIKit

class ForgottenPassController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var logInButton: UIButton!{
        didSet{
            logInButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
           
        }
    }
    @IBOutlet weak var pleaseMsgLabel: UILabel!{
        didSet{
            pleaseMsgLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        }
    }
    @IBOutlet weak var recoverEmailText: UITextField!{
        didSet{
            recoverEmailText.backgroundColor = .clear
            recoverEmailText.layer.borderColor = UIColor.white.cgColor
            recoverEmailText.layer.borderWidth = 2
            recoverEmailText.layer.cornerRadius = 25
            recoverEmailText.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            recoverEmailText.leftView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height:recoverEmailText.frame.height))
            recoverEmailText.leftViewMode = .always
            recoverEmailText.textColor = UIColor.white
        }
    }
    @IBOutlet weak var sendEmailButton: UIButton!{
        didSet{
            sendEmailButton.layer.cornerRadius = 25
            sendEmailButton.backgroundColor = UIColor.white
            sendEmailButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)
        }
    }
    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var passwordSentLabel: UILabel!
    
    //Static properties
    static let notificationName = Notification.Name("messagesFromPassReset")
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.hideKeyboardWhenTappedAround()
        
        //Listen for events related to Firebase reset password
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: ForgottenPassController.notificationName, object: nil)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: ForgottenPassController.notificationName, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgottenPassController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Manage Keyboard overlap
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            print("Do nothing")
        default:
            print("Do Scroll")
            scrollView.setContentOffset(CGPoint(x:0,y:100) , animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func onNotification(notification:Notification)
    {
        let notif: String = notification.userInfo?["result"] as! String
        if notif == "successfullPasswordReset" {
            let alertController = UIAlertController(title: "Success", message: "Password reset email sent.", preferredStyle: .alert)
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
    
    @IBAction func backToLogInF(_ sender: Any) {
        let vc = self.storyboard?.instantiateInitialViewController()
        self.present(vc!, animated: false, completion: nil)
    }
  
    @IBAction func sendEmail(_ sender: Any) {
        if recoverEmailText.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            PlaceServices.shared.sendPasswordReset(email: recoverEmailText.text!)
        }
    }
    
}
