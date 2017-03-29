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
		
		spinner.isHidden = true
		
		// Set text field attributes
		for field in [locationField, websiteField] {
			field!.defaultTextAttributes = textFieldAttributes
			field!.placeholder = (field == locationField) ? "Enter location" : "Enter website"
		}
	}
	
	func dismissView() {
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	func postButtonPressed(_ sender: UIButton) {
		
		spinner.isHidden = false
		spinner.startAnimating()
		
		ParseClient.sharedInstance().updateLocation(location: locationField.text!, website: websiteField.text!) { (success, error) in
			print("Wonderful is: \(success)")
		}
	}
}
