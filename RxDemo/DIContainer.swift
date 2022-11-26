//
//  DIContainer.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 29/07/22.
//

import Foundation

let container = DIContainer()

class DIContainer {

    typealias Resolver = (DIContainer) -> AnyObject
    var map: [String: Resolver] = [:]

    func register<T>(type: T.Type, resolver: @escaping Resolver) {
        let typeString = String(reflecting: type)
        map[typeString] = resolver
    }

    func resolve<T>() -> T {
        let typeString = String(reflecting: T.self)
        guard let resolver = map[typeString],
        let resolvedObject = resolver(self) as? T else {
            fatalError("No dependancy available for type \(typeString)")
        }

        return resolvedObject
    }

    func resolve<T>(type: T.Type) -> T {
        resolve()
    }
}

class A {
    init(b: B) {}
}

class B {
    init(c: C) {}
}

class C {}


