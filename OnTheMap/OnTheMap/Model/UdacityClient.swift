//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
	
	
	
	func taskForPOST(parameters: [String: AnyObject], jsonBody: String, completionHandler: @escaping (_ results: AnyObject?, _ error: String?) -> Void ) {
		
		/* 1. Set parameters */
		let username = parameters[ParameterKeys.Username]
		let password = parameters[ParameterKeys.Password]
		let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \" password\": \"\(password)\"}}"
		
		/* 2. Build URL */
		let url = URL(string: Constants.Scheme + "://" + Constants.Host + Constants.Path)
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = httpBody.data(using: String.Encoding.utf8)
		
		/* 4. Make request */
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in

			guard error != nil else {
				print("There was an error")
				return
			}
			
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				print("Server returned status code other than 2xx")
				return
			}
			
			guard let data = data else {
				print("No data was returned")
				return
			}
		
		/* 5/6. Parse data */
			
		}
		/* 7. Start request */
		task.resume()
		return task
	}
	
}
