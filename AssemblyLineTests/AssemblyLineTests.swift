//
//  AssemblyLineTests.swift
//  AssemblyLineTests
//
//  Created by 1amageek on 2017/04/13.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Quick
import Nimble
@testable import AssemblyLine

class AssemblyLineTests: QuickSpec {
    
    override func spec() {
        describe("ModelX Factory") {
            
            let assembly: Step<ModelX> = Step({ (product) -> ModelX in
                print("assembly")
                sleep(1)
                return product
            })
            
            describe("Step manufactring is not nil", {
                expect(assembly.manufacturing).toNot(beNil())
            })
            

            
            let paint: Step<ModelX> = Step({ (product) -> ModelX in
                print("paint")
                sleep(1)
                return product
            })
            
            let line: Line<ModelX, ModelXPackage> = Line(workflow: [assembly, paint])
            
            (0..<10).forEach({ (index) in
                let product: ModelX = ModelX()
                line.generate(product)
            })
            
            print(line)

            it("Package") {
                let package: ModelXPackage = line.packing(block: { (products) -> ModelXPackage in
                    return ModelXPackage(products: products)
                })
                expect(package.products.count).to(equal(10))
            }
            
        }
    }
    
}
