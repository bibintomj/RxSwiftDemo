//
//  ViewController.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 06/07/22.
//

import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

//Observable<String>.create { obs in      // created observer with given type String
//    obs.onNext("A")                     // Manually emitting next event with value "A"
//    obs.onNext("B")
//    obs.onCompleted()                   // emits completed event
//
//    return Disposables.create()          // For this method to create observer, you need to return Disposable.
//}
//.subscribe(onNext: { print($0) },
//           onError: { print($0) },
//           onCompleted: { print("Completed") },
//           onDisposed: { print("Disposed") }
//)
//.disposed(by: disposeBag)












func doSomething() {
    let obs = Observable.of(1, 2, 3)
    obs.subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
}

//
//Observable<String>.create { obs in      // created observer with given type String
//    obs.onNext("A")                     // Manually emitting next event with value "A"
//    obs.onNext("B")
//    obs.onCompleted()                   // emits completed event
//
//    return Disposables.create()          // For this method to create observer, you need to return DisposeBag.
//}
//.subscribe( onNext: { print($0) },
//            onError: { print($0) },
//            onCompleted: { print("Completed") },
//            onDisposed: { print("Disposed") }
//)
//.disposed(by: disposeBag)



// Observable
func run1() {
    let obs1 = Observable.just(1) // Used when its only one element
    let obs2 = Observable.of(1, 2, 3) // Subscribers get values one by one
    let obs3 = Observable.of(UIColor.blue, .cyan, .brown)
    let obs4 = Observable.from(["A", "B", "C"]) // Must pass in array

    obs1.subscribe { event in
        //            print(event.debugDescription)
        guard let _ = event.element else {
            return
        }
    }
    .disposed(by: disposeBag)

    obs1.subscribe { color in
        print(color)
    } onError: { print($0)
    } onCompleted: { print("Completed")
    } onDisposed: { print("Disposed")
    }
    .disposed(by: disposeBag)

}

// Publish Subject
func run2() {
    let subject: PublishSubject<String> = .init()
    subject.subscribe {
        print("1. \($0)")
    }

    subject.subscribe {
        print("2. \($0)")
    }

    subject.onNext("Emit 1")

//    let obs = Observable.just("SomeString")
//    obs.subscribe(subject)
//        .disposed(by: disposeBag)

    subject.onNext("Emit 2") //  Wont do anything, cu

}

//run2()

// Behvaviour Subject & Replay Subjects
func run3() {
//    let subject = BehaviorSubject(value: "Emit 1")
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    //        let subject = ReplaySubject<String>.createUnbounded() // infinite size. Be careful. memory leak could happen.
    subject.onNext("Emit 2")
    subject.subscribe(onNext: {
        print("1st ", $0)
    })
    subject.onNext("Emit 3")
    subject.subscribe(onNext: {
        print("2nd ", $0)
    })
}

//run3()

// Variable [Depricated] & BehaviourRelay
func run4() {
    //        let variable = Variable("Emit 1")
    //        variable.value = "Emit 2"
    //        variable.subscribe {
    //            print($0)
    //        }

    let relay = BehaviorRelay(value: [1,2,3])
    relay.accept(relay.value + [4])

    relay
    //        .take(until: self.rx.deallocated) // Another way to dispose.
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}
run4()

//run1()
//run2()
//run3()
//run4()

