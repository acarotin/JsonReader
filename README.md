# JsonReader

Swift 4.0 offers a great way to read Json files since **JSONSerialization** can turn a Data into a value of type **Any** that can be cast in array, dictionnary or every other type of variable found in a json file.

We can basically read json from a data like this :

```swift
let jsonContent = """
    {
        \"person\" : [
            {
                \"name\": \"Bob\",
                \"age\": 16,
                \"employed\": false,
                \"nil\": null
            },
            {
                \"name\": \"Vinny\",
                \"age\": 56,
                \"employed\": true
            }
        ]
    }
"""

print(jsonContent)

let data = jsonContent.data(using: .utf8)!

let jsonResult = try JSONSerialization.jsonObject(with: data,
                                                  options: .mutableContainers)
```

The only problem with this approach is that we have to cast our object of type **Any** into a lot of differents types.

The point of this package is to turn big syntax like this :

```swift
if let dictionnary = jsonResult as? [String: Any] {
    if let array = dictionnary["person"] as? [Any] {
        if let secondDictionnary = array[0] as? [String: Any] {
            if let name = secondDictionnary["name"] as? String {
                print(name)
            }
        }
    }
}
```

Into something like this :

```swift
let object = JsonObject(json: jsonResult)
if let name = object["person"]?[0]?["name"]?.stringValue {
    print(name)
}
```

To do so, we turn the json result into an enumeration that define wich type it is :
```swift
indirect enum JsonObject {
    case dictionnary([String: JsonObject])
    case array([JsonObject])
    case string(String)
    case integer(Int)
    case float(Double)
    case none
    
    [...]
```

We can create instances directly from the result of the **JSONSerialisation** method using the init with **Any** :

```swift
    init(json: Any) {
        [...]
    }
```

Two subscript methods are present. One taking a **String** and assuming we're using a dictionnary and one taking an **Int** and assuming we're an array. Both of them will return nil if it's not the case.
The Dictionary will return nil if the key doesn't exist and the Array will return nil if the index is too high.

```swift
    subscript(key: String) -> JsonObject? {
        [...]
    }
    
    subscript(index: Int) -> JsonObject? {
        [...]
    }
```

This enumeration is conform to the protocols **Equatable** and **CustomStringConvertible** wich description will return a JSON formatted string describing itself.

So this code bellow will simply show "I'm equal to myself" :

```swift
let recastedObject = JsonObject(json: try! JSONSerialization.jsonObject(with: object.description.data(using: .utf8)!, options: .allowFragments))
if object == recastedObject {
    print("I'm equal to myself")
}
```
