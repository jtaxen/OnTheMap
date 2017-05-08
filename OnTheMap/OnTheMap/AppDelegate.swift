//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	var sessionID: String? = nil
	var uniqueKey: String?
	var objectID: String? = nil
	
	/**
	Function for checking server responses for different possible errors. This function prints the error if it finds any.
	- Parameter data: Data returned from the server, or nil if no data was returned.
	- Parameter response: Response from server including status code.
	- Parameter error: Error sent by the server.
	- Returns: The error if any, or nil if everything is in order.
	*/
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
	
	/**
	Parses the JSON response from the server to an array of dictionaries.
	- Parameter data: The data which is to be parsed.
	- Parameter isUdacityData: If set to true, the function removes the first five characters from the data before it parses.
	- Parameter results: The results of the parsing.
	- Parameter error: The error information, or nil, if everything went well.
	*/
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
	
	/**
	Converts a list of dictionaries to a list of student locations.
	*/
	func extractStudentLocations(from parameters: [[String: AnyObject]]) -> [StudentLocation] {
		
		var list: [StudentLocation] = []
		
		for item in parameters {
			list.append(StudentLocation(item))
		}
		return list
	}
}

