//
//  RxNetwork.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 28/07/22.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}
extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: URLRequest(url: url))
            }
            .map { response, data -> T in
                guard 200..<300 ~= response.statusCode else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }

                return try JSONDecoder().decode(T.self, from: data)
            }
    }



//    // This is just the API call pipeline. Not the actual call. This will only be executed when there is a subscriber attached to it.
//    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
//        return Observable.just(resource.url)
//            .flatMap { url -> Observable<Data> in
//                print("Loading Resource")
//                return URLSession.shared.rx.data(request: .init(url: url))
//            }
//            .map {
//                try JSONDecoder().decode(T.self, from: $0)
//            }
//    }
}


