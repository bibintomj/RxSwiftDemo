//
//  DependancyPropertyWrapper.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 29/07/22.
//

import Foundation

@propertyWrapper
class Dependancy<T> {
    var wrappedValue: T

    init() { self.wrappedValue = container.resolve() }
}
