//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


// this line tells the Playground to execute indefinitely
// PlaygroundPage.current.needsIndefiniteExecution = true

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
request.httpBody = "{\"udacity\": {\"username\": \"\", \"password\": \"********\"}}".data(using: String.Encoding.utf8)
print(request)

let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
	if error != nil { // Handle error…
		print("Error")
		return
	}
print(data)
}
task.resume()

let s1 = "hej"
let s2 = "Hej \(s1), hemskt mycket \(s1)"
print(s2)*/

/*
struct g {
	static let a = "alfa"
	static let b = "beta"
	static let c = "gamma"
}

let list: [String: Int] = [
	g.a: 3,
	g.b: 2,
	g.c: 1
]

var st = list.description
st = st.replacingOccurrences(of: "[", with: "{")
print(st)

let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
request.addValue("", forHTTPHeaderField: "X-Parse-Application-Id")
request.addValue("", forHTTPHeaderField: "X-Parse-REST-API-Key")
let session = URLSession.shared
let task = session.dataTask(with: request as URLRequest) { data, response, error in
	if error != nil { // Handle error...
		return
	}
	var parsedData: [String: AnyObject]!
	do {
		parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
		print("Data parsing successful: \(data)")
//		print(parsedData)
	} catch {
		let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed: \(data)"]
	}
	
	let fafa = parsedData["results"]! as! [[String:AnyObject]]
	print(fafa[0])
	//[String: AnyObject]
	print(fafa[0]["mediaURL"]!)
}
task.resume()
*/
/*

var newURLComponents = URLComponents()

newURLComponents.scheme = "https"
newURLComponents.host = "parse.udacity.com"
newURLComponents.path = "/parse/classes/StudentLocation"
newURLComponents.queryItems = []

let parameters = ["Hej": "hopp",
"krakel": "spektakel",
"abra": "kadabra"]

for (key, value) in parameters {

	let item = URLQueryItem(name: key, value: value)
	newURLComponents.queryItems?.append(item)
}

print(newURLComponents.url!)

let st1 = "abcd"
let st2: String? = nil
print(st1 + (st2 ?? "ijk"))

let dict = ["a":"1", "b":"2", "c":"3"]
let jsonthing = try? JSONSerialization.data(withJSONObject: dict)


*/


let string = "abcdefgh"

print(string.substring(from: string.index(before: string.endIndex)))
print(string.substring(to: string.index(before: string.endIndex)))