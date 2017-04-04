//
//  ControllerProtocol.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-04-04.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

/**
Protocol just to make sure that both the children of the navigation view controller have an UIActivityIndicatorView.
*/
protocol ControllerProtocol {
	
	weak var spinner: UIActivityIndicatorView! { get set }
	
}
