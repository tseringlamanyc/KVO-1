import UIKit

/*
 KVO - Key value observer (observer pattern)
     - 1 to many pattern relationship as oppose to delegation (1:1)

 Objective C Runtime
 - required
 - needs to be class
 - inherit from NSObject is top abstract class in objective c
 - Any property being marked for observation needs to be prefixed with @objc dynamic (the property needs to be in dynamically dispatched) (Dynamic dispatched - compiler verifies the underlying property) (Swift types are statically dispatched)
  - Static vs dynamic
 */

@objc  // mark
class Dog: NSObject {  // inherit
    // Dog class is subject 
    var name: String
    @objc dynamic var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class DogWalker {  // observer 1
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // property being observerd , very similar to listener (firebase)
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        // dog is a KVO object
        // \.age is keypath
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // update
            guard let newAge = change.newValue, let oldAge = change.oldValue else {return}
            print("The dog name is \(dog.name), newage is \(newAge) from dogwalker class")
            print("Old age:\(oldAge), new age: \(newAge) dogwalker class\n")
        })
    }
}

class DogGrommer { // observer 2
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            guard let newAge = change.newValue, let oldAge = change.oldValue else {return}
            print("The dog name is \(dog.name), newage is \(newAge) from doggrommer class")
            print("Old age:\(oldAge), new age: \(newAge) doggrommer class\n")
        })
    }
}

// testing for both observers

let snoopy = Dog(name: "Snoopy", age: 5)

// both dogwalker and doggrommer have reference to snoopy
let dogWalker = DogWalker(dog: snoopy)
let dogGrommer = DogGrommer(dog: snoopy)

snoopy.age += 1 // (5 -> 6)
