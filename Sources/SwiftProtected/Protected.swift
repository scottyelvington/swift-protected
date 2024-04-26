//
//  Protected.swift
//
//
//  Created by Scott Yelvington on 4/22/24.
//

import Foundation

@propertyWrapper
public final class Protected<Root, Value>: AbstractProtected<Root> {
    
    public init(
        _ keyPath: WritableKeyPath<Root, Value>
    ) {
        
        self.keyPath = keyPath
        
        super.init()
    }
    
    private final let keyPath: WritableKeyPath<Root, Value>
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: keyPath) }
        set { table!.write(value: newValue, keyPath: keyPath) }
    }
}
