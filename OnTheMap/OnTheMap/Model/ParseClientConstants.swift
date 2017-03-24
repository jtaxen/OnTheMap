//
//  ParseClientConstants.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

// MARK: ParseClient (Constants)

extension ParseClient {

	// MARK: Constants
	struct Constants {
		
		// MARK: Keys
		static let ApplicationID = Keys.ParseApplicationID
		static let APIKey = Keys.ParseRESTAPIKey
		
		// MARK: Method URL
		static let Scheme = "https"
		static let Host = "parse.udacity.com"
		static let Path = "/parse/classes/StudemtLocation/"
		
	}
	
	
	
	// MARK: Parameter keys
	struct ParameterKeys {
		
		// MARK: GET parameters
		static let Limit = "limit"
		static let Skip = "skip"
		static let Order = "order"
		static let Where = "where"
		
		//MARK: PUT parameters
		static let ObjectID = "objectId"
		
	}
	
	// MARK: StudentLocation object keys
	// These are used as parameter value for parameter key "Order"
	// Negative sign in front of the value indicates reverse order
	struct StudentLocationKeys {
		static let ObjectID = "objectId"
		static let UniqueKey = Keys.UniqueKey
		static let FirstName = "firstName"
		static let LastName = "lastName"
		static let MapString = "mapString"
		static let MediaURL = "mediaURL"
		static let Latitude = "latitude"
		static let Longitude = "longitude"
		static let CreatedAt = "createdAt"
		static let UpdatedAt = "updatedAt"
		static let ACL = "ACL"
		
		
	}
	
}
