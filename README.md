# Juice

[![CI Status](http://img.shields.io/travis/rundfunk47/Juice.svg?style=flat)](https://travis-ci.org/rundfunk47/Juice)
[![Version](https://img.shields.io/cocoapods/v/Juice.svg?style=flat)](http://cocoapods.org/pods/Juice)
[![License](https://img.shields.io/cocoapods/l/Juice.svg?style=flat)](http://cocoapods.org/pods/Juice)
[![Platform](https://img.shields.io/cocoapods/p/Juice.svg?style=flat)](http://cocoapods.org/pods/Juice)

🍎 Juice is a modern and simple JSON Encoder / Decoder for Swift 3 🍎

## Features:
* Written to take full advantage of Swift's ability to throw errors.
* If a required parameter is missing or the wrong type, Juice will tell you exactly which model and key - for easy debugging.
* Easy to use. No weird `<*>` `<|?>` `<:3>`-operators. Just use `decode`, Juice will figure out the rest.
* Ability to transform values when encoding / decoding.
* ...and of course many, many test cases!

## Usage:

To make a model Decodable and Encodable:
```swift
struct Person: Decodable, Encodable {
    let title: String
    let firstName: String
    let lastName: String
    let age: Int
    let car: Car?
    let children: [Person]
    
    init(fromJson json: JSONDictionary) throws {
        title = try json.decode(["name", "title"])
        firstName = try json.decode(["name", "fullName", "firstName"])
        lastName = try json.decode(["name", "fullName", "lastName"])
        age = try json.decode("age")
        car = try json.decode("car")
        children = try json.decode("children")
    }
    
    func encode() throws -> JSONDictionary {
        var dictionary = JSONDictionary()
        try dictionary.encode(["name", "title"], value: title)
        try dictionary.encode(["name", "fullName", "firstName"], value: firstName)
        try dictionary.encode(["name", "fullName", "lastName"], value: lastName)
        try dictionary.encode(["age"], value: age)
        try dictionary.encode(["car"], value: car)
        try dictionary.encode(["children"], value: children)
        return dictionary
    }
}
```

A Decodable and Encodable enum with raw value:
```swift
enum PhoneNumberType: String, Decodable, Encodable {
    case home
    case office
    case mobile
}
```

A decodable enum without raw value:
```swift
enum Distance: Decodable {
    case reallyClose
    case close
    case far
    
    init(fromJson json: Double) throws {
        switch json {
        case _ where json < 2:
            self = .reallyClose
        case _ where json < 6:
            self = .close
        default:
            self = .far
        }
    }
}
```

With Juice it is possible to decode any type by using either transforms...
```swift
struct TransformHomePage {
    let title: String
    let url: URL
    
    init(fromJson json: JSONDictionary) throws {
        title = try json.decode("title")
        url = try json.decode("url", transform: { (input: String) -> URL in
            if let url = URL(string: input) {
                return url
            } else {
                throw BadURLError(attemptedUrl: input)
            }
        })
    }
}
```

...or by using protocol extensions:
```swift
extension URL: Decodable {
    public init(fromJson json: String) throws {
        if let url = URL(string: json) {
            self = url
        } else {
            throw BadURLError(attemptedUrl: json)
        }
    }
}

struct ProtocolHomePage {
    let title: String
    let url: URL
    
    init(fromJson json: JSONDictionary) throws {
        title = try json.decode("title")
        url = try json.decode("url")
    }
}
```

...and on classes you can't directly modify:

```swift
extension NSURL: FactoryDecodable {
    public static func create<T>(fromJson json: String) throws -> T {
        if let url = NSURL(string: json) {
            return url as! T
        } else {
            throw BadURLError(attemptedUrl: json)
        }
    }
}

struct ProtocolHomePage {
    let title: String
    let url: NSURL
    
    init(fromJson json: JSONDictionary) throws {
        title = try json.decode("title")
        url = try json.decode("url")
    }
}
```

Juice features precise error throwing:
```swift
do {
    let dict = JSONDictionary(["title": "Apple", "url": "ht tps://apple.com"])
    try ProtocolHomePage(fromJson: dict)
} catch {
    // Error at key path ["url"]: Failure when attempting to decode type URL: Not a valid URL: "ht tps://apple.com"
    print(error.localizedDescription)
}
```

## Example

To run the example playground, clone the repo, and run `pod install` from the Example directory first. Then, open the `Juice.xcworkspace` and play around in the playground! Also, see the unit tests for more examples. 

## Requirements

Juice has been tested with iOS 8.0+

## Installation

Juice is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Juice"
```

## Author

Narek Mailian, narek.mailian@gmail.com

## License

Juice is available under the MIT license. See the LICENSE file for more info.
