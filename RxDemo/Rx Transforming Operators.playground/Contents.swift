import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
let strikesSubject: PublishSubject<String> = .init()


func toArrayOperator() {
    strikesSubject
        .toArray()
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("AA")
    strikesSubject.onNext("BB")
    strikesSubject.onNext("CC")
    strikesSubject.onNext("D")
    strikesSubject.onNext("EE")
    print("emitted all; waiting to complete")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        strikesSubject.onCompleted()
    }
}
//toArrayOperator()

func mapOperator() {
    strikesSubject
        .map { "Lowercased = \($0.lowercased())" }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)

    strikesSubject.onNext("AA")
    strikesSubject.onNext("BB")
    strikesSubject.onNext("CC")
    strikesSubject.onNext("D")
    strikesSubject.onNext("EE")
//    strikesSubject.onCompleted()

}
//mapOperator()




struct Student {
    var score: BehaviorRelay<Int>
}

func flatMapOperator1() {
    let john = Student(score: .init(value: 90))
    let mary = Student(score: .init(value: 92))

    let student: PublishSubject<Student> = .init()
    student
        .flatMap { $0.score }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    student.onNext(john)
    student.onNext(mary)
    john.score.accept(100)
    mary.score.accept(80)


    john.score.accept(1)
    mary.score.accept(2)
}
flatMapOperator1()

struct MyTEUser {
    let firstFortNightHours: Int
    let secondFortNightHours: Int
}
func flatMapOperator2() {
    let user: PublishSubject<MyTEUser> = .init()

    user
        .flatMap {
            Observable.of($0.firstFortNightHours, $0.secondFortNightHours)
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

    let devi = MyTEUser(firstFortNightHours: 90, secondFortNightHours: 85)
    let devanshi = MyTEUser(firstFortNightHours: 80, secondFortNightHours: 85)
    let riddhi = MyTEUser(firstFortNightHours: 81, secondFortNightHours: 82)
    let swapnil = MyTEUser(firstFortNightHours: 83, secondFortNightHours: 84)

    user.onNext(devi)
    user.onNext(devanshi)
    user.onNext(riddhi)
    user.onNext(swapnil)
}

//flatMapOperator2()
