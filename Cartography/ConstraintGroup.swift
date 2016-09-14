//
//  ConstraintGroup.swift
//  Cartography
//
//  Created by Robert Böhnke on 22/01/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//

import Foundation

public final class ConstraintGroup: NSObject, NSCoding {
    private var constraints: [Constraint]

    @available(OSX, introduced: 10.10)
    @available(iOS, introduced: 8.0)
    public var isActive: Bool {
        get {
            return constraints
                .map { $0.layoutConstraint.isActive }
                .reduce(true) { $0 && $1 }
        }
        set {
            for constraint in constraints {
                constraint.layoutConstraint.isActive = newValue
            }
        }
    }

    public override init() {
        constraints = []
        super.init()
    }

    internal func replaceConstraints(_ constraints: [Constraint]) {
        for constraint in self.constraints {
            constraint.uninstall()
        }

        self.constraints = constraints

        for constraint in self.constraints {
            constraint.install()
        }
    }
    
    public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValue(forKey: "constraints") {
            constraints = aDecoder.decodeObject(forKey: "constraints")
                as? [Constraint] ?? []
        } else {
            return nil
        }
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(constraints, forKey: "constraints")
    }
}
