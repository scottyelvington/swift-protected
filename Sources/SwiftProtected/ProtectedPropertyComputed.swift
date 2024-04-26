//
//  ProtectedPropertyComputed.swift
//
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

@propertyWrapper
public final class ProtectedPropertyComputed<Root, Value>: AbstractProtected<Root> {
    
    public init(
        get getKeyPath: KeyPath<Root, () -> Value>,
        set setKeyPath: KeyPath<Root, (Value) -> Void>
    ) {
        
        self.getKeyPath = getKeyPath
        self.setKeyPath = setKeyPath
        
        super.init()
    }
    
    private final let getKeyPath: KeyPath<Root, () -> Value>
    private final let setKeyPath: KeyPath<Root, (Value) -> Void>
    
    public final var wrappedValue: Value {
        get { table!.read(keyPath: getKeyPath)() }
        set { table!.read(keyPath: setKeyPath)(newValue) }
    }
}
