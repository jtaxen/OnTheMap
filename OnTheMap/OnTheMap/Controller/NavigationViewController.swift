//
//  NavigationViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-24.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
	
	let udacityClient = UdacityClient()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationBar.items = composeNavigationItem(title: "On the map")
	}
	
	// MARK: Design navigation items
	private func composeNavigationItem(title: String) -> [UINavigationItem] {
		
		let navigationItem = UINavigationItem(title: title)
		
		let textAttributes = [
			NSFontAttributeName: UIFont(name: "Futura", size: 14),
			NSForegroundColorAttributeName: UIColor.blue
		]
		
		// Logout button
		let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(endSession))
		logoutButton.setTitleTextAttributes(textAttributes, for: .normal)
		
		
		// Refresh button
		let refreshButton = UIBarButtonItem()
		refreshButton.image = UIImage(named: "icon_refresh")
		
		// Add pin button
		let addPinButton = UIBarButtonItem()
		addPinButton.image = UIImage(named: "icon_addpin")
		
		navigationItem.leftBarButtonItem = logoutButton
		navigationItem.rightBarButtonItems = [refreshButton, addPinButton]
		return [navigationItem]
		
	}
	
	func endSession() {
		udacityClient.endSession() { (success, results, error) in
			
			guard error == nil else {
				print(error?.localizedDescription ?? "An error was detected while trying to end session.")
				return
			}
			if success {
				print("Logout was successful.")
				
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
				controller.present(controller, animated: true, completion: nil)
			}
		}
	}
}
