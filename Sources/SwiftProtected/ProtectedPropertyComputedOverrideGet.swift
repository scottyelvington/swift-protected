//
//  ProtectedPropertyOverrideGet.swift
//
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

@propertyWrapper
public final class ProtectedPropertyComputedOverrideGet<Root, Value>: AbstractProtected<Root> {
    
    public init(
        _ getKeyPath: WritableKeyPath<Root, () -> Value>
    ) {
        
        self.getKeyPath = getKeyPath
        
        super.init()
    }
    
    private final let getKeyPath: WritableKeyPath<Root, () -> Value>
    private final var superIndex: Int?
    private final var didOverride: Bool = false
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: getKeyPath)() }
    }
    
    public final var projectedValue: ProtectedPropertyComputedOverrideGet { self }
    
    public final var `super`: Value {
        
        guard let superIndex else { return wrappedValue }
        
        return table!
            .overridden(
                keyPath: getKeyPath,
                index: superIndex)()
    }
    
    public final func override(get getter: @escaping () -> Value) {
        
        guard !didOverride else { return }
        
        didOverride = true
        
        superIndex = table!
            .override(
                value: getter,
                keyPath: getKeyPath)
    }
}
