//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
	
	var sessionID: String? = nil
	
	func taskForPOST(parameters: [String: AnyObject], completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		let username = parameters[ParameterKeys.Username]!
		let password = parameters[ParameterKeys.Password]!
		let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
		
		/* 2. Build URL */
		let url = URL(string: Constants.Scheme + "://" + Constants.Host + Constants.Path)
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = httpBody.data(using: String.Encoding.utf8)
		
		/* 4. Make request */
		print("Request being sent: \(request.url!)")
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// Check to see if an error was returned
			guard error == nil else {
				completionHandler(nil, error as NSError?)
				return
			}
			
			// Make sure the server returns a 200-status code
			if let statusCode = (response as? HTTPURLResponse)?.statusCode {
				if statusCode < 200 || statusCode > 299 {
					let userInfo = [NSLocalizedDescriptionKey: "Error: Server returned status code: \(statusCode)"]
					completionHandler(nil, NSError(domain: "serverStatusCode", code: 2, userInfo: userInfo))
					return
				} else {
					print("Server returned status code \(statusCode)")
				}
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: Server did not return any status code"]
				completionHandler(nil, NSError(domain: "serverStatusCode", code: 3, userInfo: userInfo))
				return
			}
			
			// Make sure data was returned
			guard let data = data else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: no data was returned"]
				completionHandler(nil, NSError(domain: "noDataReturned", code: 4, userInfo: userInfo))
				return
			}
		
		/* 5/6. Parse data */
			self.parseData(data, completionHandlerForParsedData: completionHandler)
		}
		/* 7. Start request */
		task.resume()
		return task
	}
	
	private func parseData(_ data: Data, completionHandlerForParsedData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
	
		// Remove five first characters
		let range = Range(5 ..< data.count)
		let newData = data.subdata(in: range)
		
		
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
	
	// MARK: Shared instance
	class func sharedInstance() -> UdacityClient {
		struct Singelton {
			static var sharedInstance = UdacityClient()
		}
		return Singelton.sharedInstance
	}
	
}
