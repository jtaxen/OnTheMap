//
//  UdacityClientConstants.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

extension UdacityClient {

	/// API location
	struct Constants {
		static let Scheme = "https"
		static let Host = "www.udacity.com"
		static let Path = "/api/session"
	}
	
	/// Parameter keys
	struct ParameterKeys {
		static let Udacity = "udacity"
		static let Username = "username"
		static let Password = "password"
	}
}
