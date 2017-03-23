//
//  UdacityClientConvenience.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

extension UdacityClient {

	private func getSessionID(username: String, password: String , completionHandler: @escaping (_ success: Bool, _ result: String?, _ error: String?) -> Void ) {
		
		let parameters = [ParameterKeys.Username: username,
		                  ParameterKeys.Password: password]
		
		let _ = taskForPOST(parameters: parameters as [String : AnyObject]) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, nil, error)
				return
			}
			
			if let session = results["session"] as [String, AnyObject]
		
			
		
		
		
	}







}
