//
//  ParseClientParseData.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-29.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

/// MARK: Methods for parsing JSON data
extension ParseClient {
	
	/**
	Parses the results from a GET request and turns it into an array of dictionaries.
	- Parameter data: Server response in JSON format to be parsed.
	- Parameter results: Array of dictionaries if parsing is successful, nil otherwise.
	- Parameter error: Error information if the parsing fails.
	*/
	func parseGETRequest(_ data: Data, completionHandlerForParsedData: (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) {
		
		var parsedData: [String: AnyObject]!
		do {
			parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
			completionHandlerForParsedData(parsedData["results"]! as? [[String: AnyObject]], nil)
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
			completionHandlerForParsedData(nil, NSError(domain: "parsedDataError", code: 8, userInfo: userInfo))
		}
	}
	
	/**
	Parses the results from a POST request and turns it into an array of dictionaries.
	- Parameter data: Server response in JSON format to be parsed.
	- Parameter results: Array of dictionaries if parsing is successful, nil otherwise.
	- Parameter error: Error information if the parsing fails.
	*/
	func parsePOSTRequest(_ data: Data, completionHandlerForParsedData: (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) {
		
		var parsedData: [String: AnyObject]!
		do {
			parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
			completionHandlerForParsedData([parsedData!], nil)
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
			completionHandlerForParsedData(nil, NSError(domain: "parsedDataError", code: 8, userInfo: userInfo))
		}
	}
}
