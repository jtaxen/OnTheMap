//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	var sessionID: String? = nil
	var locationData: [[String:AnyObject]]!
	var userData: [[String:AnyObject]]?
	var uniqueKey: String?
	var objectID: String? = nil
	
	
	func checkRequestResultsForError(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> NSError? {
		
		// Check to see if an error was returned
		guard error == nil else {
			return error as NSError?
		}
		
		// Make sure the server returns a 200-status code
		if let statusCode = (response as? HTTPURLResponse)?.statusCode {
			if statusCode < 200 || statusCode > 299 {
				let userInfo = [NSLocalizedDescriptionKey: "Error: Server returned status code: \(statusCode)"]
				return NSError(domain: "serverStatusCode", code: 2, userInfo: userInfo)
			} else {
				print("Server returned status code \(statusCode)")
			}
		} else {
			let userInfo = [NSLocalizedDescriptionKey: "Error: Server did not return any status code"]
			return NSError(domain: "serverStatusCode", code: 3, userInfo: userInfo)
		}
		
		// Make sure data was returned
		guard data != nil else {
			let userInfo = [NSLocalizedDescriptionKey: "Error: no data was returned"]
			return NSError(domain: "noDataReturned", code: 4, userInfo: userInfo)
		}
		
		// If no errors were found
		return nil
	}
	
	func parseData(_ data: Data, isUdacityData: Bool, completionHandlerForParsedData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
		
		var newData: Data
		
		if isUdacityData {
			// Remove five first characters
			let range = Range(5 ..< data.count)
			newData = data.subdata(in: range)
		} else {
			newData = data
		}
		
		
		var parsedData: AnyObject! = nil
		do {
			parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
			print("Data parsing successful")
			print(parsedData)
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
			completionHandlerForParsedData(nil, NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
		}
		completionHandlerForParsedData(parsedData, nil)
	}
	
	func hardCodedLocationData() -> [[String : AnyObject]] {
		return  [
			[
				"createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
				"firstName" : "Jessica" as AnyObject,
				"lastName" : "Uelmen" as AnyObject,
				"latitude" : 28.1461248 as AnyObject,
				"longitude" : -82.75676799999999 as AnyObject,
				"mapString" : "Tarpon Springs, FL" as AnyObject,
				"mediaURL" : "www.linkedin.com/in/jessicauelmen/en" as AnyObject,
				"objectId" : "kj18GEaWD8" as AnyObject,
				"uniqueKey" : 872458750 as AnyObject,
				"updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
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

