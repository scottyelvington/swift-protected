//
//  ProtectedGet.swift
//
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

@propertyWrapper
public final class ProtectedGet<Root, Value>: AbstractProtected<Root> {
    
    public init(
        _ keyPath: KeyPath<Root, Value>
    ) {
        
        self.keyPath = keyPath
        
        super.init()
    }
    
    private final let keyPath: KeyPath<Root, Value>
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: keyPath) }
    }
}
