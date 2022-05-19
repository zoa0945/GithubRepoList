import Foundation
import RxSwift

// 하나의 element를 방출
print("=====Just=====")
Observable<Int>.just(1)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

// 여러개의 element를 순차적으로 방출
print("=====Of=====")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

Observable.of([1, 2, 3, 4, 5])
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

// Array형태의 element의 각각의 요소를 방출
print("=====From=====")
Observable.from([1, 2, 3, 4, 5])
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("=====subscribe1=====")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("=====subscribe2=====")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

// 타입추론이 안되기 때문에 타입을 명시해주어야 완료이벤트가 진행됨
print("=====empty=====")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }

print("=====never=====")
Observable.never()
    .debug("never")
    .subscribe {
        print($0)
    } onCompleted: {
        print("completed")
    }

print("=====range=====")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })

print("=====dispose=====")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose()

print("=====disposeBag=====")
var disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("=====create1=====")
Observable.create { observer -> Disposable in
    observer.on(.next(1))
    observer.on(.completed)
    observer.on(.next(2))
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

print("=====create2=====")
enum MyError: Error {
    case anError
}
Observable.create { observer -> Disposable in
    observer.on(.next(1))
    observer.on(.error(MyError.anError))
    observer.on(.completed)
    observer.on(.next(2))
    return Disposables.create()
}
.subscribe {
    print($0)
} onError: {
    print($0.localizedDescription)
} onCompleted: {
    print("completed")
} onDisposed: {
    print("disposed")
}
.disposed(by: disposeBag)

print("=====deferred1=====")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

print("=====deferred2=====")
var hand: Bool = false

let factory: Observable<String> = Observable.deferred {
    hand = !hand
    
    if hand {
        return Observable.of("Myhand")
    } else {
        return Observable.of("Yourhand")
    }
}

for _ in 0..<3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}

