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
    
    private var isStopped: Bool = false
    
    private(set) var products: [Product] = []
    
    public init(id: String = UUID().uuidString,
         workflow: [Step<Product>],
         queue: DispatchQueue = DispatchQueue(label: "line.queue")) {
        self.id = id
        self.workflow = workflow
        self.queue = queue
    }
    
    @discardableResult
    public func generate(_ product: Product) -> Product {
        let workItem: DispatchWorkItem
        var product: Product = product
        let workflow: [Step<Product>] = self.workflow
        workItem = DispatchWorkItem { [weak self] in
            for step in workflow {
                product = step.execute(product)
                if let error: Error = product.error {
                    product.dispose(error)
                    self?.remove(product)
                    break
                }
                if product.workItem!.isCancelled {
                    product.dispose(nil)
                    self?.remove(product)
                    break
                }
            }
        }
        product.workItem = workItem
        self.products.append(product)
        self.queue.async(group: group, execute: workItem)
        return product
    }
    
    public func remove(_ product: Product) {
        if let index: Int = self.products.index(of: product) {
            self.products.remove(at: index)
        }
    }
    
    public func stop() {
        self.isStopped = true
        self.products.forEach { (product) in
            product.workItem?.cancel()
        }
        self.products.removeAll()
    }
    
    public func dispose() {
        self.stop()
        self.products.forEach { (product) in
            product.dispose(nil)
        }
    }
    
    public func packing(block: @escaping ([Product], Bool) -> Void) {
        if isStopped {
            block([], self.isStopped)
            return
        }
        let queue: DispatchQueue = DispatchQueue(label: "line.package.queue")
        queue.async {
            _ = self.group.wait(timeout: .distantFuture)
            DispatchQueue.main.async {
                block(self.products, self.isStopped)
            }
        }
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
