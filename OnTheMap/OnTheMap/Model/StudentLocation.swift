//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-04-04.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

struct StudentLocation {
	
	init(_ parameters: [String: AnyObject]) {
		
		FirstName = parameters["firstName"]
		LastName = parameters["lastName"]
		MapString = parameters["mapString"]
		Latitude = parameters["latitude"]
		Longitude = parameters["longitude"]
		MediaURL = parameters["mediaURL"]
	}
	
	let FirstName: AnyObject?
	let LastName: AnyObject?
	let MapString: AnyObject?
	let Latitude: AnyObject?
	let Longitude: AnyObject?
	let MediaURL: AnyObject?
}
