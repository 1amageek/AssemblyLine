//
//  ViewController.swift
//  TeslaFactory
//
//  Created by 1amageek on 2017/04/15.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit
import AssemblyLine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let assembly: Step<ModelX> = Step({ (product) -> ModelX in
            product.isAssembled = true
            return product
        })
        
        let paint: Step<ModelX> = Step({ (product) -> ModelX in
            product.color = .white
            return product
        })
        
        let line: Line<ModelX, ModelXPackage> = Line(workflow: [assembly, paint])
        (0..<10).forEach({ (index) in
            let product: ModelX = ModelX()
            line.generate(product)
        })
        
        line.packing { (products, isStopped) in
            print("Package")
        }
        
        print("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

