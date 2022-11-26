import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

let fetch = Observable.just(1)
    .delay(.seconds(1), scheduler: MainScheduler.instance)

Observable.just(Int.random(in: 0...999))
    .flatMap { (value: Int) -> Observable<Int> in
        if value % 2 == 0 {
            return fetch
        } else {
            return Observable<Int>
                .error(NSError(domain: "",
                               code: 1,
                               userInfo: [NSLocalizedDescriptionKey: "Error from network"]))
        }
    }
    .subscribe (onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


//===========

struct Resource<T> {
    let url: URL
}
extension URLRequest {
    // This is just the API call pipeline. Not the actual call. This will only be executed when there is a subscriber attached to it.
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap {
                URLSession.shared.rx.data(request: .init(url: $0))
            }
            .map {
                try JSONDecoder().decode(T.self, from: $0)
            }
    }
}

