//
//  CustomTabBarViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-28.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = OnTheMapTools.Colors.Blue
		tabBar.barTintColor = OnTheMapTools.Colors.White
		tabBar.unselectedItemTintColor = OnTheMapTools.Colors.Gray
		
		
		// Add delimiters bewteen tab bar items
		addDelimiters(0)
	}
	
	private func addDelimiters(_ offset: CGFloat) {
		
		let height = tabBar.bounds.height
		let numberOfItems = CGFloat(viewControllers!.count)
		let itemWidth = CGFloat(tabBar.frame.width/numberOfItems)
		
		for (index, _) in viewControllers!.enumerated() {
			if index > 0 {
				let x = itemWidth * CGFloat(index)
				let delimiter = UIView(frame: CGRect(x: x, y: offset, width: 1, height: height-offset))
				delimiter.backgroundColor = OnTheMapTools.Colors.Red
				tabBar.insertSubview(delimiter, at: 1)
			}
		}
	}
}
