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

enum ModelXError: Error {
    case invalid
}

class ModelX: Processable {
    
    typealias Status = ModelXStatus
    
    var error: Error?
    var id: String
    var status: Status
    var workItem: DispatchWorkItem?
    
    var isAssembled: Bool = false
    
    var color: UIColor?
    
    init() {
        self.id = UUID().uuidString
        self.status = .spec        
    }
    
    func dispose(_ error: Error?) {
        
    }
    
}

struct ModelXPackage: Packageable {
    var products: [ModelX]
}
