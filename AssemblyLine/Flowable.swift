//
//  Flowable.swift
//  AssemblyLine
//
//  Created by 1amageek on 2017/04/13.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation

public protocol Status { }

public protocol Processable: Hashable {
    associatedtype T: Status
    var id: String { get }
    var status: T { set get }
    var workItem: DispatchWorkItem { set get }
    func dispose()
}

extension Processable {
    var hashValue: Int { return self.id.hash }
}

public func == <T: Processable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}

public protocol Flowable {
    associatedtype Product: Processable
    var block: (Product) -> Product { get }
    init(block: @escaping (Product) -> Product)
    func execute<T: Processable>(_ product: T) -> T
}

extension Flowable {
    public func execute(_ product: Product) -> Product {
        return self.block(product)
    }
}

public protocol Packageable {
    
}
