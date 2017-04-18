//
//  Assembly.swift
//  AssemblyLine
//
//  Created by 1amageek on 2017/04/13.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation

public protocol StatusProtocol { }

public protocol Processable: class, Hashable {
    associatedtype Status: StatusProtocol
    var error: Error? { get }
    var id: String { get }
    var status: Status { set get }
    var workItem: DispatchWorkItem? { set get }
    func dispose(_ error: Error?)
}

extension Processable {
    public var hashValue: Int { return self.id.hash }
}

public func == <T: Processable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}

public class Step<Product: Processable> {
    
    public typealias Input = Product
    public typealias Output = Product
    
    public var manufacturing: (Input) -> Output

    public init(_ manufacturing: @escaping (Input) -> Output) {
        self.manufacturing = manufacturing
    }
    
    public func execute(_ input: Input) -> Output {
        return manufacturing(input)
    }

}

public protocol Packageable { }
