//
//  ProtectedPropertyComputedGet.swift
//
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

@propertyWrapper
public final class ProtectedPropertyComputedGet<Root, Value>: AbstractProtected<Root> {
    
    public init(
        _ getKeyPath: KeyPath<Root, () -> Value>
    ) {
        
        self.getKeyPath = getKeyPath
        
        super.init()
    }
    
    private final let getKeyPath: KeyPath<Root, () -> Value>
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: getKeyPath)() }
    }
}
