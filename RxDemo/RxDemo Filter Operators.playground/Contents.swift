import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let strikesSubject: PublishSubject<String> = .init()

// ignoreElements
func ignoreElementsOperator() {
    strikesSubject
        .ignoreElements() // ignores all elements (next events); but passes through the completed or error events
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    strikesSubject.onNext("1") // nothing happens
    strikesSubject.onNext("2") // nothing happens
    strikesSubject.onCompleted() // prints completed
}
//ignoreElementsOperator()


func elementAtOperator() {
    strikesSubject
        .element(at: 2)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("1") // [0]
    strikesSubject.onNext("2") // [1]
    strikesSubject.onNext("3") // [2] <- Only this will be printed
    strikesSubject.onNext("4")
    strikesSubject.onNext("5")
    strikesSubject.onNext("6")
}
//elementAtOperator()

func filterOperator() {
    strikesSubject
        .filter { $0.lowercased() == "ab" }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("b")
    strikesSubject.onNext("AB") // passed to subscriber
    strikesSubject.onNext("b")
    strikesSubject.onNext("ab") // passed to subscriber
}
//filterOperator()


func skipOperator() {
    strikesSubject
        .skip(2)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("A") // will be skipped
    strikesSubject.onNext("B") // will be skipped
    strikesSubject.onNext("C") // Subscriber gets this
    strikesSubject.onNext("D") // Subscriber gets this
    strikesSubject.onNext("E") // Subscriber gets this
}
//skipOperator()

func skipWhileOperator() {
    strikesSubject
        .skip(while: {
            $0.count == 1
        })
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("A") // Condition true; will be skipped
    strikesSubject.onNext("B") // Condition true; will be skipped
    strikesSubject.onNext("CC") // FALSE; Subscriber gets this
    strikesSubject.onNext("D") // TRUE; But still passes through; Subscriber gets this
    strikesSubject.onNext("E") // TRUE; But still passes through; Subscriber gets this
}
//skipWhileOperator()

let triggerSubject: PublishSubject<String> = .init()
func skipUntilOperator() {
    strikesSubject
        .skip(until: triggerSubject)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("A") // Skips
    strikesSubject.onNext("B") // Skips

    // 👇🏻 emitting to the dependant subject. This will trigger subscriptions.
    // NOTE: this has to be next event. No complete or error will trigger.
    triggerSubject.onNext("XYZ")

    strikesSubject.onNext("C") // Subscriber gets this
    strikesSubject.onNext("D") // Subscriber gets this
    strikesSubject.onNext("E") // Subscriber gets this
}
//skipUntilOperator()


func takeOperator() {
    strikesSubject
//        .take(2)
//        .takeLast(2)
//        .take(while: {
//            $0.count > 1
//        })
        .take(until: triggerSubject)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("AA")
    strikesSubject.onNext("BB")
    strikesSubject.onNext("CC")
    triggerSubject.onNext("CA")
    strikesSubject.onNext("D")
    strikesSubject.onNext("EE")
    strikesSubject.onCompleted()
}
takeOperator()

