//
//  NavigationViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-24.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

/**
Navigation view controller for map and table view.
- Logout button ends the session and logs out the user.
- Add point button updates the user's location and website url.
- Refresh button downloads new location data from the server and updates the lists.
*/
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
	
	/** MARK: Design navigation items
	- Parameter title: Title shown in the navigation view
	- Returns: Array of navigation items: logout button, add pin button, refresh button
	*/
	private func composeNavigationItem(title: String) -> [UINavigationItem] {
		
		let navigationItem = UINavigationItem(title: title)
		
		let textAttributes = [
			NSFontAttributeName: UIFont(name: "Futura", size: 14),
			NSForegroundColorAttributeName: OnTheMapTools.Colors.Icons
		]
		
		/// Logout button
		let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(endSession))
		logoutButton.setTitleTextAttributes(textAttributes, for: .normal)
		
		
		/// Refresh button
		let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))
		refreshButton.tintColor = OnTheMapTools.Colors.Icons
		
		
		/// Add pin button
		let addPinButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocation))
		addPinButton.tintColor = OnTheMapTools.Colors.Icons
		
		navigationItem.leftBarButtonItem = logoutButton
		navigationItem.rightBarButtonItems = [refreshButton, addPinButton]
		return [navigationItem]
		
	}
}

// MARK: Button functionallity
extension NavigationViewController {
	
	/// Ends session and logs out the user, and returns to login view.
	func endSession() {
		
		//		let child = childViewControllers[0] as! MapViewController
		//		child.spinner.startAnimating()
		
		view.isUserInteractionEnabled = false
		
		udacityClient.endSession() { (success, results, error) in
			
			guard error == nil else {
				DispatchQueue.main.async {
					//					child.spinner.stopAnimating()
					self.view.isUserInteractionEnabled = true
				}
				print(error.debugDescription)
				return
			}
			if success {
				print("Logout was successful.")
				
				DispatchQueue.main.async {
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	/// Updates the location array by calling the server, and sends a notification to map and table view to update themselves.
	func refresh() {
		view.isUserInteractionEnabled = false
		parseClient.refresh() { (success, error) in
			guard error == nil else {
				DispatchQueue.main.async{
					let alert = UIAlertController(title: "Update failed", message: "Please make sure that your network is working and try again", preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
					alert.addAction(action)
					self.present(alert, animated: true, completion: nil)
					
					self.view.isUserInteractionEnabled = true
				}
				print(error.debugDescription)
				return
			}
			DispatchQueue.main.async {
				self.view.isUserInteractionEnabled = true
				NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
			}
		}
	}
	
	/// Presents AddPointViewController
	func addLocation() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "AddPointNavigation") as! UINavigationController
		present(controller, animated: true, completion: nil)
	}
}
