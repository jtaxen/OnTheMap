//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set text field attributes
		for field in [usernameTextField, passwordTextField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == usernameTextField) ? "Username (email address)" : "Password"
		}
		passwordTextField.isSecureTextEntry = true
		
	}
	
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			UdacityClient.sharedInstance().getSessionID(username: username, password: password) { (success, result, error) in
				if success {
					print("Login successful. Session ID: \(result!)")
				} else {
					print("Login unsuccessful")
					print(error!)
				}
			}
		}
	}
}
