//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	var appDelegate: AppDelegate!
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// AppDelegate
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		// Set text field attributes
		for field in [usernameTextField, passwordTextField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == usernameTextField) ? "Username (email address)" : "Password"
			field!.autocapitalizationType = UITextAutocapitalizationType.none
		}
		passwordTextField.isSecureTextEntry = true
		
	}
	
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			UdacityClient.sharedInstance().getSessionID(username: username, password: password) { (success, result, error) in
				if success {
					self.appDelegate.sessionID = result
					print("Login successful. Session ID: \(result!)")
					DispatchQueue.main.async {
						self.pushToMapView()
					}
				} else {
					print("Login unsuccessful")
					print(error!)
				}
			}
		}
	}
	
	func pushToMapView() {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
		self.present(controller, animated: true, completion:  nil)
		
	}
	
}
