//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	var appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var titleText: UILabel!
	@IBOutlet weak var signUpButton: UIButton!
	
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		StudentDataSource.shared.userData = StudentLocation(StudentDataSource.shared.hardCodedLocationData()[0])
		
		view.backgroundColor = OnTheMapTools.Colors.Background
		
		// Delegates
		usernameTextField.delegate = self
		passwordTextField.delegate = self
		
		titleText.textColor = OnTheMapTools.Colors.Title
		
		signUpButton.setTitle("Not a member yet? Sign up!", for: .normal)
		signUpButton.titleLabel?.font = textFieldAttributes[NSFontAttributeName]
		signUpButton.tintColor = OnTheMapTools.Colors.Light
		
		labelView.layer.cornerRadius = 10
		labelView.backgroundColor = OnTheMapTools.Colors.Light
		
		loginButton.layer.cornerRadius = 5
		loginButton.backgroundColor = OnTheMapTools.Colors.Dark
		loginButton.setTitleColor(OnTheMapTools.Colors.Light, for: .normal)

		
		spinner.hidesWhenStopped = true
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		
		/// Set text field attributes
		for field in [usernameTextField, passwordTextField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == usernameTextField) ? "Username (email address)" : "Password"
			field!.autocapitalizationType = UITextAutocapitalizationType.none
		}
		passwordTextField.isSecureTextEntry = true
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
		
	}
	
	/// When the login button is pressed, a call to the server is made. If the username and the password match with the user's API Key, the map view is presented.
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		
		view.isUserInteractionEnabled = false
		spinner.startAnimating()
		
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			UdacityClient.sharedInstance().getSessionID(username: username, password: password) { (success, result, error) in
				if success {
					print("Login successful.")
					DispatchQueue.main.async{
						self.pushToMapView()
					}
				} else {
					DispatchQueue.main.async {
						
						self.view.isUserInteractionEnabled = true
						self.spinner.stopAnimating()
						
						
						let alert = UIAlertController()
						// According to the code review, the error code for bad connection is -1009, but when I run it on my computer, I get -1001, so I simply added both error codes and hope it helps.
						if error?.code == -1001 || error?.code == -1009 {
							alert.title = "Bad network"
							alert.message = "Please check your internet connection and try again."
						} else {        // if error?.code == 2
							alert.title = "Failed to log in"
							alert.message = "Please make sure that you entered the correct username and password."
						}
						
						alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
					print("Login unsuccessful")
					print(error.debugDescription)
				}
			}
		}
	}
	
	@IBAction func signUpPressed(_ sender: UIButton) {
		let app = UIApplication.shared
		let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!
		app.open(url, completionHandler: nil)
	}
	
	/// Presents the map view
	func pushToMapView() {
		let parseClient = ParseClient.sharedInstance()
		_ = parseClient.refresh() { (success, error) in
			if success {
				DispatchQueue.main.async {
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
					self.spinner.stopAnimating()
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

/// MARK: Handle keyboard
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

/// MARK: Text field delegate
extension LoginViewController {
	
	/// If autocompletion adds a space after the username (which it does), this function makes sure to remove it, as it otherwise would hinder the login, and is easily missed by the user.
	func textFieldDidEndEditing(_ textField: UITextField) {
		guard textField == usernameTextField else {
			return
		}
		if let username = textField.text {
			
			if username != "" && username.substring(from: username.index(before: username.endIndex)) == " " {
				textField.text = username.substring(to: username.index(before: username.endIndex))
			}
		}
	}
	
	/// Pressing enter in the username field moves focus to the password field.
	/// Pressing enter in the password field is equivalent to touching the login button.
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
