//
//  ProtectedOverrideGet.swift
//
//
//  Created by Scott Yelvington on 4/25/24.
//

import Foundation

@propertyWrapper
public final class ProtectedOverrideGet<Root, Value>: AbstractProtected<Root> {
    
    public init(
        _ keyPath: WritableKeyPath<Root, Value>
    ) {
        
        self.keyPath = keyPath
        
        super.init()
    }
    
    private final let keyPath: WritableKeyPath<Root, Value>
    private final var superIndex: Int?
    private final var didOverride: Bool = false
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: keyPath) }
    }
    
    public final var projectedValue: ProtectedOverrideGet { self }
    
    public final var `super`: Value {
        
        guard let superIndex = superIndex else { return wrappedValue }
        
        return table!
            .overridden(
                keyPath: keyPath,
                index: superIndex)
    }
    
    public final func override(_ methodOrValue: Value) {
        
        guard !didOverride else { return }
        
        didOverride = true
        
        superIndex = table!
            .override(
                value: methodOrValue,
                keyPath: keyPath)
    }
}
