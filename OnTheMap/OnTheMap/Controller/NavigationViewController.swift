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
	let parseClient = ParseClient()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationBar.items = composeNavigationItem(title: "On the map")
		navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: OnTheMapTools.Colors.Title]
		view.backgroundColor = OnTheMapTools.Colors.Background
		view.layer.borderColor = OnTheMapTools.Colors.Dark.cgColor
	}
	
	// MARK: Design navigation items
	private func composeNavigationItem(title: String) -> [UINavigationItem] {
		
		let navigationItem = UINavigationItem(title: title)
		
		let textAttributes = [
			NSFontAttributeName: UIFont(name: "Futura", size: 14),
			NSForegroundColorAttributeName: OnTheMapTools.Colors.Icons
		]
		
		// Logout button
		let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(endSession))
		logoutButton.setTitleTextAttributes(textAttributes, for: .normal)
		
		
		// Refresh button
		let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))
		refreshButton.tintColor = OnTheMapTools.Colors.Icons
		
		
		// Add pin button
		let addPinButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocation))
		addPinButton.tintColor = OnTheMapTools.Colors.Icons
		
		navigationItem.leftBarButtonItem = logoutButton
		navigationItem.rightBarButtonItems = [refreshButton, addPinButton]
		return [navigationItem]
		
	}
}

// MARK: Button functionallity
extension NavigationViewController {

	func endSession() {
		udacityClient.endSession() { (success, results, error) in
			
			guard error == nil else {
				print(error?.localizedDescription ?? "An error was detected while trying to end session.")
				return
			}
			if success {
				print("Logout was successful.")
				
				DispatchQueue.main.async {
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
				self.present(controller, animated: true, completion: nil)
				}
			}
		}
	}
	
	func refresh() {
		parseClient.refresh() { (success, error) in
			
			guard error == nil else {
				print(error?.localizedDescription ?? "Unable to refresh.")
				return
			}
		}
	}
	
	func addLocation() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "AddPointNavigation") as! UINavigationController
		present(controller, animated: true, completion: nil)
	}
	
	
}
