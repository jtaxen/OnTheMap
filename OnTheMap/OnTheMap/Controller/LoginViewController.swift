//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	var appDelegate: AppDelegate!
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var titleText: UILabel!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = OnTheMapTools.Colors.Background
		
		// Delegates
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		usernameTextField.delegate = self
		passwordTextField.delegate = self
		
		titleText.textColor = OnTheMapTools.Colors.Title
		
		labelView.layer.cornerRadius = 10
		labelView.backgroundColor = OnTheMapTools.Colors.Light
		
		loginButton.layer.cornerRadius = 5
		loginButton.backgroundColor = OnTheMapTools.Colors.Dark
		loginButton.setTitleColor(OnTheMapTools.Colors.Light, for: .normal)
		
		spinner.isHidden = true
		
		// Set text field attributes
		for field in [usernameTextField, passwordTextField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == usernameTextField) ? "Username (email address)" : "Password"
			field!.autocapitalizationType = UITextAutocapitalizationType.none
		}
		passwordTextField.isSecureTextEntry = true
		
	}
	
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		
		spinner.isHidden = false
		spinner.startAnimating()
		
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			UdacityClient.sharedInstance().getSessionID(username: username, password: password) { (success, result, error) in
				if success {
					self.appDelegate.sessionID = result
					print("Login successful.")
					DispatchQueue.main.async {
						self.pushToMapView()
					}
				} else {
					DispatchQueue.main.async {
						self.spinner.isHidden = true
					}
					print("Login unsuccessful")
					print(error!)
				}
			}
		}
	}
	
	func pushToMapView() {
		let parseClient = ParseClient()
		_ = parseClient.refresh() { (success, error) in
			if success {
				DispatchQueue.main.async {
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
					self.present(controller, animated: true, completion:  nil)
				}
			} else {
				print(error!.localizedDescription)
			}
		}
	}
	
}

// MARK: Handle keyboard
extension LoginViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotification()
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow , object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	func unsubscribeFromKeyboardNotification() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWillShow(_ notification: Notification) {
//		view.frame.origin.y = -getKeyboardHeight(notification)
	}
	
	func keyboardWillHide(_ notification: Notification) {
//		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
}

// MARK: Text field delegate
extension LoginViewController {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == usernameTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			loginButtonPressed(loginButton)
		}
		return true
	}
}
