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
            context("White ModelX assembly line", {
                
                let assembly: Step<ModelX> = Step({ (product) -> ModelX in
                    product.isAssembled = true
                    return product
                })
                
                let paint: Step<ModelX> = Step({ (product) -> ModelX in
                    product.color = .white
                    return product
                })
                
                it("Step manufactring is not nil") {
                    expect(assembly.manufacturing).toNot(beNil())
                }
                
                let line: Line<ModelX, ModelXPackage> = Line(workflow: [assembly, paint])
                (0..<10).forEach({ (index) in
                    let product: ModelX = ModelX()
                    line.generate(product)
                })
                
                waitUntil(action: { (done) in
                    line.packing { (products, isStopped) in
                        let package = ModelXPackage(products: products)
                        it("Genrate 10 units") {
                            expect(line.products.count).to(equal(10))
                        }
                        
                        it("Package") {
                            expect(package.products.count).to(equal(10))
                        }
                        
                        it("ModelX is assembled") {
                            package.products.forEach({ (modelX) in
                                expect(modelX.isAssembled).to(equal(true))
                            })
                        }
                        
                        it("ModelX is white color") {
                            package.products.forEach({ (modelX) in
                                expect(modelX.color!).to(equal(UIColor.white))
                            })
                        }
                        
                        done()
                    }
                })

            })
            
            context("ModelX assembly bad line", {
                
                var count: Int = 0
                
                let badStep: Step<ModelX> = Step({ (product) -> ModelX in
                    product.isAssembled = true
                    if count % 2 == 0 {
                        product.error = ModelXError.invalid
                    }
                    count += 1
                    return product
                })
                
                it("Step manufactring is not nil") {
                    expect(badStep.manufacturing).toNot(beNil())
                }
                
                let line: Line<ModelX, ModelXPackage> = Line(workflow: [badStep])
                (0..<10).forEach({ (index) in
                    let product: ModelX = ModelX()
                    line.generate(product)
                })
                
                waitUntil(action: { (done) in
                    line.packing { (products, isStopped) in
                        let package = ModelXPackage(products: products)
                        
                        it("Genrate 5 units") {
                            expect(line.products.count).to(equal(5))
                        }
                        
                        it("Package") {
                            expect(package.products.count).to(equal(5))
                        }
                        
                        it("ModelX is assembled") {
                            package.products.forEach({ (modelX) in
                                expect(modelX.isAssembled).to(equal(true))
                            })
                        }
                        done()
                    }
                })
                
            })
            
        }
    }
    
}
