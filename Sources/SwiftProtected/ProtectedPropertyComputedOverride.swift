//
//  ProtectedPropertyComputedOverride.swift
//
//
//  Created by Scott Yelvington on 4/25/24.
//

import Foundation

@propertyWrapper
public final class ProtectedPropertyComputedOverride<Root, Value>: AbstractProtected<Root> {
    
    public init(
        get getKeyPath: WritableKeyPath<Root, () -> Value>,
        set setKeyPath: WritableKeyPath<Root, (Value) -> Void>
    ) {
        
        self.getKeyPath = getKeyPath
        self.setKeyPath = setKeyPath

        super.init()
    }
    
    private final let getKeyPath: WritableKeyPath<Root, () -> Value>
    private final let setKeyPath: WritableKeyPath<Root, (Value) -> Void>
    private final var superGetIndex: Int?
    private final var superSetIndex: Int?
    private final var didOverride: Bool = false
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: getKeyPath)() }
        set { table!.read(keyPath: setKeyPath)(newValue) }
    }
    
    public final var projectedValue: ProtectedPropertyComputedOverride { self }
    
    public final var `super`: Value {
        get {
            
            guard let superGetIndex else { return wrappedValue }
            
            return table!
                .overridden(
                    keyPath: getKeyPath,
                    index: superGetIndex)()
        }
        set {
            
            guard let superSetIndex else {
                
                wrappedValue = newValue
                
                return
            }
            
            return table!
                .overridden(
                    keyPath: setKeyPath,
                    index: superSetIndex)(newValue)
        }
    }
    
    public final func override(
        get getter: @escaping () -> Value,
        set setter: @escaping (Value) -> ()
    ) {
        
        guard !didOverride else { return }
        
        didOverride = true
        
        superGetIndex = table!
            .override(
                value: getter,
                keyPath: getKeyPath)
        
        superSetIndex = table!
            .override(
                value: setter,
                keyPath: setKeyPath)
    }
}
