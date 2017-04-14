//
//  Line.swift
//  AssemblyLine
//
//  Created by 1amageek on 2017/04/13.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation

public class Line <Product: Processable, Package: Packageable> {

    public let id: String
    
    public let queue: DispatchQueue
    
    public let group: DispatchGroup = DispatchGroup()
    
    public let workflow: [Step<Product>]
    
    private(set) var products: [Product] = []
    
    init(id: String = UUID().uuidString,
         workflow: [Step<Product>],
         queue: DispatchQueue = DispatchQueue(label: "line.queue")) {
        self.id = id
        self.workflow = workflow
        self.queue = queue
    }
    
    public func generate(_ product: Product) {
        let workItem: DispatchWorkItem
        var product: Product = product
        workItem = DispatchWorkItem {
            self.workflow.forEach({ (step) in
                product = step.execute(product)
            })
        }
        product.workItem = workItem
        self.products.append(product)
        self.queue.async(group: group, execute: workItem)
    }
    
    public func stop() {
        self.products.forEach { (product) in
            product.workItem?.cancel()
        }
    }
    
    public func dispose() {
        self.stop()
        self.products.forEach { (product) in
            product.dispose()
        }
    }
    
    public func packing(block: ([Product]) -> Package) -> Package {
        _ = self.group.wait(timeout: .distantFuture)
        return block(self.products)
    }
    
}

extension Line: Hashable {
    public var hashValue: Int {
        return self.id.hash
    }
}

public func == <Product: Processable, Package: Packageable>(lhs: Line<Product, Package>, rhs: Line<Product, Package>) -> Bool {
    return lhs.id == rhs.id
}
