//
//  LoginController.swift
//  Facegram
//
//  Created by Dominic Ong on 2/19/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  @IBOutlet weak var usernameField: TranslucentTextField!
  @IBOutlet weak var passwordField: TranslucentTextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.borderWidth = 1
    loginButton.layer.cornerRadius = 5
    loginButton.layer.borderColor = UIColor.lightTextColor().CGColor
    
    usernameField.placeholderText = "Username"
    passwordField.placeholderText = "Password"
    
    usernameField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    passwordField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
  
  func textFieldDidChange(textfield: UITextField!) {
    if let username = usernameField.text where !username.isEmpty,
      let password = passwordField.text where !password.isEmpty {
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.enabled = true
    } else {
      loginButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
      loginButton.enabled = false
    }
  }
  
  @IBAction func loginTapped(button: UIButton!) {
    guard let username = usernameField.text where !username.isEmpty,
      let password = passwordField.text where !password.isEmpty else {
        return
    }
    activityIndicator.startAnimating()
    login(username, password: password)
  }
  
  @IBAction func signupTapped(button: UIButton!) {
    let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let registerController = mainSB.instantiateViewControllerWithIdentifier("Register") as! RegisterController
    registerController.delegate = self
    presentViewController(registerController, animated: true, completion: nil)
  }
  
  func login(email: String, password: String) {
    firebase.authUser(email, password: password, withCompletionBlock: { error, result in
      if error != nil {
        print(error.localizedDescription)
        self.activityIndicator.stopAnimating()
        return
      }
      let uid = result.uid
      usernameRef.childByAppendingPath(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
        guard let username = snapshot.value as? String else {
          print("No user found for \(email)")
          self.activityIndicator.stopAnimating()
          return
        }
        profileRef.childByAppendingPath(username).observeSingleEventOfType(.Value, withBlock: { snapshot in
          self.activityIndicator.stopAnimating()
          guard let profile = snapshot.value as? [String : AnyObject] else {
            print("No profile found for user")
            return
          }
          Profile.currentUser = Profile.initWithUsername(username, profileDict: profile)
          let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
          let rootController = mainSB.instantiateViewControllerWithIdentifier("Tabs")
          self.presentViewController(rootController, animated: true, completion: nil)
        })
      })
    })
  }
}

extension LoginController: RegisterControllerDelegate {
  func registerControllerDidCancel(controller: RegisterController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func registerControllerDidFinishWithCredentials(controller: RegisterController, email: String) {
    usernameField.text = email
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}
