//
//  AddPointViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-28.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

/**
View controller for creating or updating the location for a user.

*/
class AddPointViewController: UIViewController {
	
	var appDelegate: AppDelegate!
	var parseClient = ParseClient.sharedInstance()
	
	var locationIsNotFound = true
	var locationString: String? = nil
	var websiteString: String? = nil
	
	@IBOutlet weak var textFieldContainer: UIView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var postButton: UIButton!
	@IBOutlet weak var map: MKMapView!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		/// AppDelegate
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		/// UI Setup
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
		postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
		
		view.backgroundColor = OnTheMapTools.Colors.Background
		textFieldContainer.backgroundColor = OnTheMapTools.Colors.Light
		textFieldContainer.layer.cornerRadius = 10
		
		postButton.titleLabel?.text = "Find"
		postButton.layer.cornerRadius = 5
		postButton.backgroundColor = OnTheMapTools.Colors.Dark
		postButton.setTitleColor(OnTheMapTools.Colors.Light, for: .normal)
		
		textFieldContainer.layer.cornerRadius = 10
		postButton.layer.cornerRadius = 5
		
		spinner.hidesWhenStopped = true
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		
		/// Set text field attributes
		textField.defaultTextAttributes = textFieldAttributes
		textField.placeholder = "Enter your location"
		
		label.text = "Where are you right now?"
		
		// Prepare map
		let frame = CGRect(x: CGFloat(0) , y: view.frame.height , width: view.frame.width, height: CGFloat(0))
		map.frame = frame
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
	}
	
	/// Keyboard is dismissed when the user taps outside of it.
	func dismissView() {
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	func showMap() {
		map.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.5) { () -> Void in
			self.map.frame = self.view.frame
			self.map.layoutIfNeeded()
		}
	}
	
	/// Sends the updated user information to the server and dismisses the view.
	func postButtonPressed(_ sender: UIButton) {
		
		if locationIsNotFound {
			if textField.text != nil {
				locationString = textField.text
				if let coordinates = ParseClient.sharedInstance().findLocation(locationString!) {
					label.text = "What do you want to share?"
					textField.text = ""
					textField.placeholder = "Enter a website"
					postButton.titleLabel?.text = "Submit"
					map.centerCoordinate = coordinates
					showMap()
					locationIsNotFound = false
				} else {
					textField.text = ""
					let alert = UIAlertController(title: "Location not found", message: "Your location was not recognized. Please try again.", preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alert.addAction(action)
					present(alert, animated: true, completion: nil)
				}
			} else {
				return
			}
		} else {
			if textField.text != nil {
				websiteString = textField.text
				parseClient.updateLocation(location: locationString, website: websiteString!) { (success, error) in
				}
				
			}
		}
	}
}

/// MARK: Handle keyboard
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

/// MARK: Text field delegate
extension AddPointViewController {
	
	/// Pressing enter is like pushing the button
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		postButtonPressed(postButton)
		return true
	}
}
