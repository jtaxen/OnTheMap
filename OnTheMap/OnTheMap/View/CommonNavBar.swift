//
//  CommonNavBar.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-24.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class CommonNavBar: UINavigationBar, UINavigationBarDelegate {
	
	var logoutButton: UIBarButtonItem!
	var refreshButton: UIBarButtonItem!
	var addButton: UIBarButtonItem!
	
	
	convenience override init(frame: CGRect) {
		
		self.init(frame: frame)
		
		self.titleTextAttributes = [
			NSFontAttributeName: UIFont(name: "Futura", size: 20)!
		]
		
		self.items?.append(composeNavigationItem())
		
	}
	
	private func composeNavigationItem() -> UINavigationItem {
		
		let navigationItem = UINavigationItem(title: "On the map")
		
		// Logout button
		logoutButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Futura", size: 10)!], for: .normal)
		logoutButton.title = "Logout"
		
		// Refresh button
		refreshButton.image = UIImage(named: "icon_refresh")
		
		// Add pin button
		addButton.image = UIImage(named: "icon_addpin")
		
		navigationItem.leftBarButtonItem = logoutButton
		navigationItem.rightBarButtonItems = [refreshButton, addButton]
		
		return navigationItem
	}
	
	

}
