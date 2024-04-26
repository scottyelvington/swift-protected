# SwiftProtected

SwiftProtected is a library designed for Swift developers looking to integrate the protected access modifier into their Swift projects. Traditionally absent in Swift's access control system, the protected modifier is common in many other object-oriented programming languages, enabling properties and methods to be accessible within the defining class and its subclasses, but not outside these bounds.

This library uses property wrappers to bring this functionality to Swift, enhancing encapsulation and allowing for safer, more organized codebases that respect the principles of object-oriented design.

## Features
- **Simplified Access**: Separate access from inheritance. Share private vars and methods between parent and children effortlessly.
- **Computed Properties**: Use getter and setter functions in place of stored properties.
- **Override Properties and Methods**: Override any property or method in your table and call super when needed.
- **Multiple Dispatch Tables**: Multiple levels of protection are supported. Super classes and child classes can have independent tables extending object oriented functionality.

## Installation and Integration

SwiftProtected can be installed via CocoaPods or Swift Package Manager, making it easy to add to your project.

### Using CocoaPods
To integrate SwiftProtected into your Xcode project using CocoaPods, add the following line to your Podfile:
```ruby
pod 'SwiftProtected'
```
Then, run the pod install command to download and integrate the library into your workspace.

### Using Swift Package Manager
For those preferring Swift Package Manager, add SwiftProtected as a dependency in your Package.swift file:
```swift
    dependencies: [
        .package(
            url: "https://github.com/scottyelvington/swift-protected",
            from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: [
                .product(
                    name: "SwiftProtected",
                    package: "swift-protected"),
            ]),
    ]
```
## Usage
### Step 1: Define a Nested Type with Protected Properties
The first step in using SwiftProtected is to define a nested type within your class. For beginners, start with a struct. This struct will contain the properties you want to mark as protected on this class, making them accessible only within the class and its subclasses. Since it's a struct, it obeys all the rules of swift. You can set default values or computed properties, you can build functions and much much more.
```swift
class Vehicle {

    struct VehicleTable {
        var speed: Int
        var maxSpeed: Int
    }
}
```

### Step 2: Initialize the Type in the Class's init Statement
After creating your table of protected properties, use @PropertyTable to initialize the table in your class's init statement. ***This step is required.*** If you forget it, any get or set access to protected properties will result in a crash due to the fact that the properties do not have a table to access.
```swift
class Vehicle {

    init() {
        @PropertyTable(on: self)
        var table = ProtectedProperties(
            speed: 0,
            maxSpeed: 120)
    }

    struct VehicleTable {
        var speed: Int
        var maxSpeed: Int
    }
}
```

### Step 3: Use @Protected to Initialize Protected Properties on the Super Class and Child Class
Add the @Protected property wrapper on any of your class's protected properties to gain access to the protected properties.
```swift
class Vehicle {

    init() {
        @PropertyTable(on: self)
        var table = VehicleTable(
            speed: 0,
            maxSpeed: 120)
    }

    struct VehicleTable {
        var speed: Int
        let maxSpeed: Int
    }

    @Protected(\VehicleTable.speed)
    private var speed: Int

    @ProtectedGet(\VehicleTable.maxSpeed)
    private var maxSpeed: Int
}

class Car: Vehicle {

    init() {
      super.init()
    }

    @Protected(\VehicleTable.speed)
    private var speed: Int

    @ProtectedGet(\VehicleTable.maxSpeed)
    private var maxSpeed: int
}
```
Now all child classes of the class that declared the @PropertyTable have inherited access to the protected properties. Note that In the naming convention of SwiftProtected, properties that get only have the word Get in the title. Whereas properties that get/set do not.

### Other Nifty Things!
Swift Protected also offers getters and setters, methods, as well as overriding properties/methods! This pairs nicely with the `Retainable` package offered at: https://github.com/scottyelvington/retainable.
```swift
import Retainable

class Vehicle: Retainable {

    init() {
        @PropertyTable(on: self)
        var table = VehicleTable(
            getSpeed: unowned(Vehicle.getSpeed),
            maxSpeed: unowned(Vehicle.setSpeed))
    }

    struct VehicleTable {
        var getSpeed: () -> Int
        var setSpeed: (Int) -> Void
    }

    @ProtectedPropertyComputed(
      get: \VehicleTable.getSpeed,
      set: \VehicleTable.setSpeed)
    private var speed: Int

    private var _speed: Int
    private var isMetric: Bool

    private func getSpeed() -> Int {
        if isMetric {
          return _speed * /* some calculation */
        } else {
          return _speed * /* some other calculation */
        }
    }

    private var setSpeed(speed: Int) {
        _speed = speed * /* some calculation */
    }
}
```
Here the Retainable framework passes in weakly retained geter setter functions from your parent class to the PropertyTable. Then the ProtectedPropertyComputed wrapper refers to the getter/setter any time you get or set from that property calling the parent class's functions!

```swift
class Car: Vehicle {

    init() {
        super.init()
        $getSpeed.override(unowned(Car.getAccurateSpeed))
    }

    @ProtectedPropertyComputed(
      get: \VehicleTable.getSpeed,
      set: \VehicleTable.setSpeed)
    private var speed: Int
    
    @ProtectedOverrideMethod(\VehicleTable.getSpeed)
    private var getSpeed: () -> Int
    
    private func getAccurateSpeed() -> Int {
        // call super to get parent speed
        let parentSpeed = $getSpeed.super()
        // add wind drag for accuracy
        let adjustedSpeed = parentSpeed + 10
        // pass back the new adjusted speed
        return adjustedSpeed
    } 
}
```
In the subclass, we have overridden the getter to provide a more accurate speed. The new getter has access to the super class getter. And all of this is bundled up nicely in the computed property which can be called at any time.

### Limitations
While you can declare as many types of unique protected tables as you want on the parent and child classes, you cannot declare a PropertyTable for the same type more than once. So feel free to add more protected tables to the child classes, but know that if you use the same nested type on a property table more than once, it will lead to unintended behavior.
```swift
class Vehicle {

    init() {
        @PropertyTable(on: self)
        var table = VehicleTable(
            speed: 0,
            maxSpeed: 120)
    }

    struct VehicleTable {
        var speed: Int
        let maxSpeed: Int
    }

    @Protected(\VehicleTable.speed)
    private var speed: Int

    @ProtectedGet(\VehicleTable.maxSpeed)
    private var maxSpeed: Int
}

class Car: Vehicle {

    init() {
        super.init()
        @PropertyTable(on: self)
        var table = CarTable(
            isSedan: true,
            numberOfDoors: 4)
    }

    struct CarTable {
        let isSedan: Bool
        let numberOfDoors: Int
    }

    @Protected(\VehicleTable.speed)
    private var speed: Int

    @ProtectedGet(\VehicleTable.maxSpeed)
    private var maxSpeed: int

    @ProtectedGet(\CarTable.isSedan)
    private var isSedan: Bool

    @PropertyGet(\CarTable.numberOfDoors)
    private var numberOfDoors: Int
}
```
