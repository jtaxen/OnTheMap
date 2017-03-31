//
//  AddPointViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-28.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class AddPointViewController: UIViewController {
	
	var appDelegate: AppDelegate!
	var parseClient = ParseClient.sharedInstance()
	
	@IBOutlet weak var textFieldContainer: UIView!
	@IBOutlet weak var locationField: UITextField!
	@IBOutlet weak var websiteField: UITextField!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var postButton: UIButton!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
		postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
		
		// UI Setup
		view.backgroundColor = OnTheMapTools.Colors.Background
		textFieldContainer.backgroundColor = OnTheMapTools.Colors.Light
		textFieldContainer.layer.cornerRadius = 10
		
		postButton.layer.cornerRadius = 5
		postButton.backgroundColor = OnTheMapTools.Colors.Dark
		postButton.setTitleColor(OnTheMapTools.Colors.Light, for: .normal)
		
		// AppDelegate
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		textFieldContainer.layer.cornerRadius = 10
		postButton.layer.cornerRadius = 5
		
		spinner.hidesWhenStopped = true
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		
		// Set text field attributes
		for field in [locationField, websiteField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == locationField) ? "Enter location" : "Enter website"
		}
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
	}
	
	func dismissView() {
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	func postButtonPressed(_ sender: UIButton) {
		
		spinner.startAnimating()
		
		ParseClient.sharedInstance().updateLocation(location: locationField.text!, website: websiteField.text!) { (success, error) in
			
			if success {
				print("Location was successfully updated.")
				
				DispatchQueue.main.async {
					self.dismissView()
				}
			} else {
				print(error.debugDescription)
				
				DispatchQueue.main.async {
					self.spinner.stopAnimating()
					let alert = UIAlertController(title: "Update failed", message: "The location could not be updated. Please try again", preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alert.addAction(action)
				}
			}
		}
	}
}

// MARK: Handle keyboard
extension AddPointViewController {
	
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
extension AddPointViewController {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == locationField {
			websiteField.becomeFirstResponder()
		}
		return true
	}
}
