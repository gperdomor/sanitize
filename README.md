[![Swift Version](https://img.shields.io/badge/Swift-3.1_and_4.0-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-brightgreen.svg)](http://vapor.codes)
[![Linux Build Status](https://img.shields.io/circleci/project/github/gperdomor/sanitize.svg?label=Linux)](https://circleci.com/gh/gperdomor/sanitize)
[![macOS Build Status](https://img.shields.io/travis/gperdomor/sanitize.svg?label=macOS)](https://travis-ci.org/gperdomor/sanitize)
[![codebeat badge](https://codebeat.co/badges/96ac7dc6-b1a7-4cc5-bb95-8a33f967bb65)](https://codebeat.co/projects/github-com-gperdomor-sanitize-master)
[![codecov](https://codecov.io/gh/gperdomor/sanitize/branch/master/graph/badge.svg)](https://codecov.io/gh/gperdomor/sanitize)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

# Sanitize

Powerful model extraction from JSON requests.

## Installation

Add this project to the `Package.swift` dependencies of your Vapor project:

```swift
  .Package(url: "https://github.com/gperdomor/sanitize.git", majorVersion: 1)
```

or for Swift 4:

```swift
  .package(url: "https://github.com/gperdomor/sanitize.git", from: "1.0.0")
```

## Usage

### Model

Before you're able to extract your model from a request it needs to conform to
the protocol `Sanitizable` adding a `[String]` named `allowedKeys` with a list
of keys you wish to allow:

```swift
import Sanitize

class User: Sanitizable { // or struct
    var id: Node?
    var name: String
    var email: String

    // Valid properties taken from the request json
    static var allowedKeys: [String] = ["name", "email"]

    //...
}
```

Now that you have a conforming model, you can safely extract it from a Request

### Request Body

```json
{
  "id": 1,
  "name": "John Appleseed",
  "email": "example@domain.com"
}
```

### Routes

```swift
drop.post("model") { req in
    var user: User = try req.extractModel()
    print(user.id == nil) // prints `true` because was removed (`id` is not a allowed key)
    try user.save()
    return user
}
```

### Pre and Post validations

You can also configure some `preSanitize` and `postSanitize` validations,
this validations will be executed before and after model initialization.

```swift
extension User {
    static func preSanitize(data: JSON) throws {
        guard data["name"]?.string != nil else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "No name provided."
            )
        }

        guard data["email"]?.string != nil else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "No email provided."
            )
        }
    }

    func postSanitize() throws {
        guard email.characters.count > 8 else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Email must be longer than 8 characters."
            )
        }
    }
}
```
## Credits
This package is developed and maintained by [Gustavo Perdomo](https://github.com/gperdomor).

This package is heavily inspired by [Sanitized](https://github.com/nodes-vapor/sanitized)

## License

Sanitize is released under the [MIT License](LICENSE).
