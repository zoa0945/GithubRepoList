import Foundation
import RxSwift

var disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("=====Single1=====")
Single<String>.just("Check")
    .subscribe {
        print($0)
    } onFailure: {
        print("error: \($0)")
    } onDisposed: {
        print("disposed")
    }
    .disposed(by: disposeBag)

print("=====Single2=====")
Observable.create { observer -> Disposable in
        observer.on(.error(TraitsError.single))
        return Disposables.create()
    }
    .asSingle()
    .subscribe {
        print($0)
    } onFailure: {
        print("error: \($0.localizedDescription )")
    } onDisposed: {
        print("disposed")
    }
    .disposed(by: disposeBag)

print("=====Single3=====")
struct SomeJSON: Codable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name": "young"}
    """

func decodeJSON(json: String) -> Single<SomeJSON> {
    let observable: Single<SomeJSON> = Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let result = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        
        observer(.success(result))
        return Disposables.create()
    }
    
    return observable
}

decodeJSON(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decodeJSON(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("=====Maybe1=====")
Maybe<String>.just("Good")
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

Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("success: \($0)")
    },
    onError: {
        print("error: \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("=====Completable1=====")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("=====Completable2=====")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
        print($0)
}
.disposed(by: disposeBag)
