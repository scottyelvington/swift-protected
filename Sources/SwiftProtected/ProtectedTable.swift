//
//  ProtectedTable.swift
//  
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

@propertyWrapper
public final class PropertyTable<Root> {
    
    public init<Instance>(
        wrappedValue: Root,
        on instance: Instance
    ) {
        
        self.staticTable = wrappedValue
        
        solidify(instance)
    }
    
    // MARK: - Properties
    
    // Root
    private final var staticTable: Root
    public final var wrappedValue: Root {
        get { staticTable }
    }
    
    // Dictionaries
    public final var virtualTable: [AnyHashable: [Any]] = [:]
    
    // Bools
    private final var isCemented: Bool = false
    
    // MARK: - Lifecycle
    
    @inline(__always)
    private final func solidify<T>(_ instance: T) {
        
        guard !isCemented else { return }
        
        isCemented = true
        
        mirrorAndLink(Mirror(reflecting: instance))
    }
    
    @inline(__always)
    private final func mirrorAndLink(_ mirror: Mirror) {
        
        mirror
            .children
            .map(\.value)
            .compactMap { $0 as? AbstractProtected<Root> }
            .forEach(self.link)
        
        guard let superclassMirror = mirror.superclassMirror else { return }
        
        mirrorAndLink(superclassMirror)
    }
    
    @inline(__always)
    private final func link(_ other: AbstractProtected<Root>) {
        
        other.table = self
    }
    
    // MARK: - Interface
    
    @inline(__always)
    internal final func read<Value>(keyPath: KeyPath<Root, Value>) -> Value {
        
        wrappedValue[keyPath: keyPath]
    }
    
    @inline(__always)
    internal final func write<Value>(
        value: Value,
        keyPath: WritableKeyPath<Root, Value>
    ) {
        
        staticTable[keyPath: keyPath] = value
    }
    
    @inline(__always)
    internal final func override<Value>(
        value: Value,
        keyPath: WritableKeyPath<Root, Value>
    ) -> Int {
        
        let oldValue = staticTable[keyPath: keyPath]
        
        var stack = virtualTable[keyPath] ?? []
        
        stack.append(oldValue)
        
        staticTable[keyPath: keyPath] = value
        
        let superIndex = stack.count - 1
        
        virtualTable[keyPath] = stack
        
        write(
            value: value,
            keyPath: keyPath)
        
        return superIndex
    }
    
    @inline(__always)
    internal final func overridden<Value>(
        keyPath: KeyPath<Root, Value>,
        index: Int
    ) -> Value {
        
        let stack = virtualTable[keyPath] as! [Value]
        
        return stack[index]
    }
}
