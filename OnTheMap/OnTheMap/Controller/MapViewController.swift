//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	var appDelegate: AppDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let locations = appDelegate.locationData ?? appDelegate.hardCodedLocationData()
		
		var annotations = [MKPointAnnotation]()
		
		for dictionary in locations {
			
			if let lat = dictionary["latitude"] as? Float,
				let lon = dictionary["longitude"] as? Float {
				
				let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
				
				let firstName = dictionary["firstName"] as? String ?? ""
				let lastName = dictionary["lastName"] as? String ?? ""
				let mediaUrl = dictionary["mediaURL"] as? String ?? ""
				
				let annotation = MKPointAnnotation()
				annotation.coordinate = coordinate
				annotation.title = "\(firstName) \(lastName)"
				annotation.subtitle = mediaUrl
				
				annotations.append(annotation)
			}
			mapView.addAnnotations(annotations)
		}
	}
}

// MARK: Map view delegate
extension MapViewController {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "pin"
		
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = UIColor.blue
			pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		} else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let app = UIApplication.shared
			if let toOpen = view.annotation?.subtitle! {
				let url = URL(string: toOpen)!
				app.open(url, options: [:], completionHandler: nil)
			}
		}
	}
}
