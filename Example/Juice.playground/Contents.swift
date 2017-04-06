import Juice

// To make a model Decodable and Encodable:
struct Car: Decodable, Encodable {
    let model: String
    let color: String
    
    init(fromJson json: JSONDictionary) throws {
        model = try json.decode("model")
        color = try json.decode("color")
    }
    
    func encode() throws -> JSONDictionary {
        var dictionary = JSONDictionary()
        try dictionary.encode(["model"], value: model)
        try dictionary.encode(["color"], value: color)
        return dictionary
    }
}

struct Person: Decodable, Encodable {
    let title: String
    let firstName: String
    let lastName: String
    let age: Int
    let car: Car?
    let children: [String]
    
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

let string = "{\"age\": 29, \"children\": [], \"name\": {\"title\": \"Mr.\", \"fullName\": {\"firstName\": \"John\", \"lastName\": \"Doe\"}}}"

// Create a model from a string:
let person = try! Person(fromJson: toStrictlyTypedJSON(toLooselyTypedJSON(string)) as! JSONDictionary)
try! person.encode().jsonString

// A Decodable and Encodable enum with raw value:
enum PhoneNumberType: String, Decodable, Encodable {
    case home
    case office
    case mobile
}

// A decodable enum without raw value:
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

struct BadURLError : Error, CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return 1
    }
    
    /// The domain of the error.
    public static var errorDomain = "BadURLErrorDomain"
    
    var attemptedUrl: String
    
    var localizedDescription: String {
        return "Not a valid URL: \"" + attemptedUrl + "\""
    }
}

// Possible to decode any type by using transforms:
struct TransformHomePage: Decodable {
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

// Or by using protocol extensions:
extension URL: Decodable {
    public init(fromJson json: String) throws {
        if let url = URL(string: json) {
            self = url
        } else {
            throw BadURLError(attemptedUrl: json)
        }
    }
}

// On classes you can't directly modify:
extension NSURL: FactoryDecodable {
    public static func create<T>(fromJson json: String) throws -> T {
        if let url = NSURL(string: json) {
            return url as! T
        } else {
            throw BadURLError(attemptedUrl: json)
        }
    }
}

struct ProtocolHomePage: Decodable {
    let title: String
    let url: URL
    
    init(fromJson json: JSONDictionary) throws {
        title = try json.decode("title")
        url = try json.decode("url")
    }
}

// Error catching:
do {
    let dict = JSONDictionary(["title": "Apple", "url": "ht tps://apple.com"])
    try ProtocolHomePage(fromJson: dict)
} catch {
    // Error at key path ["url"]: Failure when attempting to decode type URL: Not a valid URL: "ht tps://apple.com"
    print(error.localizedDescription)
}
