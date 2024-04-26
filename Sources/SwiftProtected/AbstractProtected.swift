//
//  AbstractProtected.swift
//  
//
//  Created by Scott Yelvington on 4/24/24.
//

import Foundation

public class AbstractProtected<Root> {
    
    internal init() {
    }
    
    internal final var table: PropertyTable<Root>?
}
