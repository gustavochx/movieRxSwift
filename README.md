
Example of Application using The Movie DB API with MVVM, more specific the frameworks: RxSwift and RxCocoa.

## RxSwift keys:

- Observable: It’s a sequence of data that we can apply transformation, then observe/subscribe to.
- Subject: It’s a sequence of data like the observable, but we can also publish next value to the subject
- Driver: It’s the same as observable, but in this case it will be guaranteed to be scheduled to run on main thread.
- BehaviorRelay: It’s a specialized Subject that we can use to set and get value like a normal variable.

