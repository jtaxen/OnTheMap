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
	}
	
	// MARK: StudentLocation object keys
	struct StudentLocationParameterKeys {
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
