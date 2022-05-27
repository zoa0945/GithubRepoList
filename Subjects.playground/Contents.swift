import Foundation
import RxSwift

let disposeBag = DisposeBag()

print("=====PublishSubject=====")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("Hello Everyone")

let subscriber1 = publishSubject
    .subscribe {
        print("subscriber1: ", $0.element ?? $0)
    }

publishSubject.onNext("Anybody There?")
publishSubject.onNext("Nobody Here")

subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe {
        print("subscriber2: ", $0.element ?? $0)
    }

publishSubject.onNext("Hello?")
publishSubject.onCompleted()

publishSubject.onNext("Finish")

subscriber2.dispose()

print("=====BehaviorSubject=====")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "init value")

behaviorSubject.onNext("first")
behaviorSubject.onNext("second")

behaviorSubject
    .subscribe {
        print("first subscriber: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

behaviorSubject.onNext("third")
behaviorSubject.onError(SubjectError.error1)

behaviorSubject
    .subscribe {
        print("second subsriber: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

behaviorSubject.onNext("fourth")

print("=====ReplaySubject=====")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("keep")
replaySubject.onNext("calm")

replaySubject
    .subscribe {
        print("first subscriber: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

replaySubject.onNext("and")

replaySubject
    .subscribe {
        print("second subscriber: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

replaySubject.onNext("carry")
replaySubject.onNext("on")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject
    .subscribe {
        print("third subscriber: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
