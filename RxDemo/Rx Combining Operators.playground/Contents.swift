import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

//===============

// Concat

func concatOperator() {
    let first = PublishSubject<Int>()
    let second = PublishSubject<Int>()

    let observable = Observable.concat([first, second])

    observable.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

    first.onNext(1)
    first.onNext(2)
    first.onNext(3)

    second.onNext(4)
    first.onCompleted()

    second.onNext(5)
    second.onNext(6)
    second.onNext(7)
    second.onCompleted()
}
//concatOperator()


//=====================

//Merge

func mergeOperator() {
    let left: PublishSubject<Int> = .init()
    let right: PublishSubject<Int> = .init()

    Observable.merge(left, right)
        .subscribe(onNext: {
            print($0)
        })

    left.onNext(1)
    right.onNext(2)
    left.onNext(3)
    right.onNext(4)
    left.onNext(5)

}
//mergeOperator()

//=====================

// CombineLatest
func combineLatestOperator() {
    let left: PublishSubject<Int> = .init()
    let right: PublishSubject<String> = .init()

    Observable.combineLatest(left, right)
        .subscribe(onNext: {
            print($0.0, $0.1)
        })
    left.onNext(1)
    left.onNext(2)
    right.onNext("A")
    right.onNext("B")
    left.onNext(3)
}
//combineLatestOperator()

//==================================

func withLatestFromOperator() {
    let button: PublishSubject<Void> = .init() // using a publishSubject to emulate button events.
    let textfield: PublishSubject<String> = .init() // using a publishSubject to emulate textField events.

    button.withLatestFrom(textfield)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

    textfield.onNext("Sw")
    textfield.onNext("Swif")
    textfield.onNext("Swift")

    button.onNext(())
    button.onNext(())
    textfield.onNext("Swift 5.5")
    button.onNext(())
}
//withLatestFromOperator()

//============================
// Reduce()

func reduceOperator() {
    let subject: PublishSubject<Int> = .init()

    subject.reduce(0, accumulator: +)
        .subscribe(onNext: {
            print($0)
        })

    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
    subject.onCompleted()
}
//reduceOperator()


//===========================
// Scan()


func scanOperator() {
    let subject: PublishSubject<Int> = .init()

    subject.scan(0, accumulator: +)
        .subscribe(onNext: {
            print($0)
        })

    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
    subject.onCompleted()
}
scanOperator()


