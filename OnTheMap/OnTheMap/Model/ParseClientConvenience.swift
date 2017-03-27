//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

extension ParseClient {

	func refresh (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: AnyObject] = [:] /*ParameterKeys.Limit: "100",
		                  ParameterKeys.Skip: "0",
		                  Para m eterKeys.Order: StudentLocationKeys.UpdatedAt*/
//		]
		
		let _ = taskForGET() { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			if let locationData = results {
				self.appDelegate.locationData = locationData
				completionHandler(true, nil)
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not parse Location data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotParseLocationData", code: 7, userInfo: userInfo))
			}
		}
	}
}