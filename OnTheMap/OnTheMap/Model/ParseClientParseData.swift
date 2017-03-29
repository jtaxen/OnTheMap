//
//  ParseClientParseData.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-29.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

// MARK: Methods for parsing JSON data
extension ParseClient {

	func parseGETRequest(_ data: Data, completionHandlerForParsedData: (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) {
		
		var parsedData: [String: AnyObject]!
		do {
			parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
			print("Data: \(data) successfully parsed.")
			completionHandlerForParsedData(parsedData["results"]! as? [[String: AnyObject]], nil)
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
			completionHandlerForParsedData(nil, NSError(domain: "parsedDataError", code: 8, userInfo: userInfo))
		}
	}
	
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
