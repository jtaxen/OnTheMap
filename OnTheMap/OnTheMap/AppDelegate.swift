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
	var locationData: [[String:AnyObject]]? = nil
	
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
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
			completionHandlerForParsedData(nil, NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
		}
		completionHandlerForParsedData(parsedData, nil)
	}
}

