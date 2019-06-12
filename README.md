# movieRxSwift
- Example using The Movie DB API with MVVM, more specific the frameworks: RxSwift and RxCocoa.

[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-10.2-blue.svg)](https://developer.apple.com/xcode)
[![Xcode](https://img.shields.io/badge/macOS-15.0-blue.svg)](https://developer.apple.com/macOS)


## Requirements
- macOS 10.14 Mojave
- Xcode 10.2 
- iOS 12

## Getting Started
- Go to https://www.themoviedb.org/documentation/api 
- Got your own registration
- Basic knowledge of reactive programming

## RxSwift keys:

- Observable: It’s a sequence of data that we can apply transformation, then observe/subscribe to.
- Subject: It’s a sequence of data like the observable, but we can also publish next value to the subject
- Driver: It’s the same as observable, but in this case it will be guaranteed to be scheduled to run on main thread.
- BehaviorRelay: It’s a specialized Subject that we can use to set and get value like a normal variable.



