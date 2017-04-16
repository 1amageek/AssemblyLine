# AssemblyLine

<img src="https://github.com/1amageek/AssemblyLine/blob/master/AssemblyLine.png" width="320px">

 [![Version](http://img.shields.io/cocoapods/v/Bleu.svg)](http://cocoapods.org/?q=AssemblyLine)
 [![Platform](http://img.shields.io/cocoapods/p/Bleu.svg)]()
 
AssemblyLine processes several tasks continuously in the background.
Discard tasks that failed during execution during execution.

## Usage 👻

Take example of Tesla's factory.

<img src="https://www.tesla.com/tesla_theme/assets/img/modelx/section-exterior-profile.jpg?20161201" width="640px">

Define Status.
``` swift
enum ModelXStatus: StatusProtocol {
    case spec
    case assembly
    case paint
}
```
Define Error.
``` swift
enum ModelXError: Error {
    case invalid
}
```

`Processable` protocol.
``` swift
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
    
    // Processing when an error occurs
    func dispose(_ error: Error?) {
        
    }
}
```

``` swift
struct ModelXPackage: Packageable {
    var products: [ModelX]
}

```

``` swift
// Define workflow steps
let assembly: Step<ModelX> = Step({ (product) -> ModelX in
    product.isAssembled = true
    return product
})

// Define workflow steps
let paint: Step<ModelX> = Step({ (product) -> ModelX in
    product.color = .white
    return product
})

// Making a manufacturing line to do workflow
let line: Line<ModelX, ModelXPackage> = Line(workflow: [assembly, paint])

// Generate 10 ModelX
(0..<10).forEach({ (index) in
    let product: ModelX = ModelX()
    line.generate(product)
})

// Packaging
line.packing { (products, isStopped) in    
    if isStopped {
        print("Line is stopped")
        return
    }
    let package = ModelXPackage(products: products)
}
```
