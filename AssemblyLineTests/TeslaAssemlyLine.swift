//
//  TeslaAssemlyLine.swift
//  AssemblyLine
//
//  Created by 1amageek on 2017/04/13.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation
import AssemblyLine

enum ModelXStatus: StatusProtocol {
    case spec
    case assembly
    case paint
}

struct ModelX: Processable {
    
    typealias Status = ModelXStatus
    
    var id: String
    var status: Status
    var workItem: DispatchWorkItem?
    
    init() {
        self.id = UUID().uuidString
        self.status = .spec        
    }
    
    func dispose() {
        
    }
    
}

struct ModelXPackage: Packageable {
    var products: [ModelX]
}

//protocol ModelXProtocol: Flowable {
//    typealias Input = ModelX
//    typealias Output = ModelX
//}
//
//struct Assembly: ModelXProtocol {
//    
//    var block: (ModelX) -> ModelX {
//        return { modelX in
//            return modelX
//        }
//    }
//
//    func execute(_ product: ModelX) -> ModelX {
//        return self.block(product)
//    }
//}
//
//struct Paint: ModelXProtocol {
//    
//    var block: (ModelX) -> ModelX {
//        return { modelX in
//            return modelX
//        }
//    }
//    
//    func execute(_ product: ModelX) -> ModelX {
//        return self.block(product)
//    }
//    
//}


