//
//  RegisterViewController.swift
//  Facegram
//
//  Created by Dominic Ong on 2/19/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit
import Firebase

protocol RegisterControllerDelegate: class{
  func registerControllerDidCancel(controller: RegisterController)
  func registerControllerDidFinishWithCredentials(controller: RegisterController, email: String)
}

class RegisterController: UIViewController {
  @IBOutlet weak var emailField: TranslucentTextField!
  @IBOutlet weak var passwordField: TranslucentTextField!
  @IBOutlet weak var usernameField: TranslucentTextField!
  @IBOutlet weak var signupButton: UIButton!
  weak var delegate: RegisterControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailField.placeholderText = "email"
    passwordField.placeholderText = "password"
    usernameField.placeholderText = "username"
    signupButton.layer.borderWidth = 1
    signupButton.layer.cornerRadius = 5
    signupButton.layer.borderColor = UIColor.lightTextColor().CGColor
  }
  
  @IBAction func registerTapped(button: UIButton) {
    guard let email = emailField.text where !email.isEmpty else {
      return
    }
    guard let password = passwordField.text where !password.isEmpty else {
      return
    }
    guard let username = usernameField.text where !username.isEmpty else {
      return
    }
    firebase.createUser(email, password: password, withValueCompletionBlock: { error, result in
      if error != nil {
        print("Error occured during registration: \(error.localizedDescription)")
        return
      }
      guard let uid = result["uid"] as? String else {
        print("Invalid uid for user: \(email)")
        return
      }
      
      usernameRef.childByAppendingPath(uid).setValue(username)
      profileRef.childByAppendingPath(username).setValue(["created": FirebaseServerValue.timestamp()])
      let alertController = UIAlertController(title: "Registration Success!", message: "Your account was successfully created with email\n\(email)", preferredStyle: .Alert)
      let dismissAction = UIAlertAction(title: "Got it", style: .Default, handler: { alertAction in
        // Return to login screen and pass the email back
        self.delegate?.registerControllerDidFinishWithCredentials(self, email: email)
      })
      alertController.addAction(dismissAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    })
  }
  
  @IBAction func loginTapped(button: UIButton) {
    delegate?.registerControllerDidCancel(self)
  }
}
