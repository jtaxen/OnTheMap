//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-05-05.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class StudentDataSource {

	var locationData = [StudentLocation]()
	var userData: StudentLocation!
	
	static let shared = StudentDataSource()
	
	private init() {}
	
	/// Hard coded locations, so that there is something to fill the map with in case of no internet connection.
	/// - Returns: an array of dictionaries with location data for default people.
	func hardCodedLocationData() -> [[String : AnyObject]] {
		return  [
			[
				"createdAt" : "2001-01-01T00:00:00.1" as AnyObject,
				"firstName" : "Default" as AnyObject,
				"lastName" : "McDefaultface" as AnyObject,
				"latitude" : 0.0 as AnyObject,
				"longitude" : 0.0 as AnyObject,
				"mapString" : "Default City, DF" as AnyObject,
				"mediaURL" : "www.default.df" as AnyObject,
				"objectId" : "abc123" as AnyObject,
				"uniqueKey" : 1234567890 as AnyObject,
				"updatedAt" : "2001-01-01T00:00:00.1" as AnyObject
			], [
				"createdAt" : "2015-02-24T22:35:30.639Z" as AnyObject,
				"firstName" : "Gabrielle" as AnyObject,
				"lastName" : "Miller-Messner" as AnyObject,
				"latitude" : 35.1740471 as AnyObject,
				"longitude" : -79.3922539 as AnyObject,
				"mapString" : "Southern Pines, NC" as AnyObject,
				"mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en" as AnyObject,
				"objectId" : "8ZEuHF5uX8" as AnyObject,
				"uniqueKey" : 2256298598 as AnyObject,
				"updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
			], [
				"createdAt" : "2015-02-24T22:30:54.442Z" as AnyObject,
				"firstName" : "Jason" as AnyObject,
				"lastName" : "Schatz" as AnyObject,
				"latitude" : 37.7617 as AnyObject,
				"longitude" : -122.4216 as AnyObject,
				"mapString" : "18th and Valencia, San Francisco, CA" as AnyObject,
				"mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29" as AnyObject,
				"objectId" : "hiz0vOTmrL" as AnyObject,
				"uniqueKey" : 2362758535 as AnyObject,
				"updatedAt" : "2015-03-10T17:20:31.828Z" as AnyObject
			], [
				"createdAt" : "2015-03-11T02:48:18.321Z" as AnyObject,
				"firstName" : "Jarrod" as AnyObject,
				"lastName" : "Parkes" as AnyObject,
				"latitude" : 34.73037 as AnyObject,
				"longitude" : -86.58611000000001 as AnyObject,
				"mapString" : "Huntsville, Alabama" as AnyObject,
				"mediaURL" : "https://linkedin.com/in/jarrodparkes" as AnyObject,
				"objectId" : "CDHfAy8sdp" as AnyObject,
				"uniqueKey" : 996618664 as AnyObject,
				"updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
			]
		]
	}
}
