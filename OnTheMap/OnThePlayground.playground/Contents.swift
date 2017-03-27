//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

/*
let urlString = "http://quotes.rest/qod.json?category=inspire"
let url = URL(string: urlString)
let request = NSMutableURLRequest(url: url!)
let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
	if error != nil {
print("Handle the error")
return
}
print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
}
task.resume()*/

/*
let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Accept")
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: String.Encoding.utf8)
print(request)

let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
	if error != nil { // Handle error…
		print("Error")
		return
	}
print(data)
}
task.resume()*/
/*
let s1 = "hej"
let s2 = "Hej \(s1), hemskt mycket \(s1)"
print(s2)*/