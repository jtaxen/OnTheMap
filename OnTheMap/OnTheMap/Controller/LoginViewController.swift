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
		
		spinner.hidesWhenStopped = true
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		
		// Set text field attributes
		for field in [usernameTextField, passwordTextField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == usernameTextField) ? "Username (email address)" : "Password"
			field!.autocapitalizationType = UITextAutocapitalizationType.none
		}
		passwordTextField.isSecureTextEntry = true
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
		
	}
	
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		
		spinner.startAnimating()
		
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			UdacityClient.sharedInstance().getSessionID(username: username, password: password) { (success, result, error) in
				if success {
					DispatchQueue.main.async{
						print("Login successful.")
						self.pushToMapView()
					}
				} else {
					DispatchQueue.main.async {
						self.spinner.stopAnimating()
						
						let alert = UIAlertController(title: "Could not log in", message: "Please make sure that you entered the correct username and password.", preferredStyle: .actionSheet)
						alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
					print("Login unsuccessful")
					print(error.debugDescription)
				}
			}
		}
	}
	
	func pushToMapView() {
		let parseClient = ParseClient.sharedInstance()
		_ = parseClient.refresh() { (success, error) in
			if success {
				DispatchQueue.main.async {
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
					self.present(controller, animated: true) {
						_ = parseClient.getUserData() { (success, error) in
							if !success {
								print(error.debugDescription)
							}
						}
					}
				}
			} else {
				print(error.debugDescription)
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
		view.frame.origin.y = (-getKeyboardHeight(notification)).multiplied(by: 0.25)
	}
	
	func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

// MARK: Text field delegate
extension LoginViewController {
	
	// If autocompletion adds a space after the username (which it does), this function makes sure to remove it, as it otherwise would hinder the login, and is easily missed by the user.
	func textFieldDidEndEditing(_ textField: UITextField) {
		guard textField == usernameTextField else {
			return
		}
		if let username = textField.text {
			if username.substring(from: username.index(before: username.endIndex)) == " " {
				textField.text = username.substring(to: username.index(before: username.endIndex))
			}
		}
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
