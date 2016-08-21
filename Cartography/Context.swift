//
//  Context.swift
//  Cartography
//
//  Created by Robert Böhnke on 06/10/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public class Context {
    internal var constraints: [Constraint] = []
    
    internal func addConstraint(
        from: Property,
        to: Property? = nil,
        coefficients: Coefficients = Coefficients(),
        relation: NSLayoutRelation = .equal
        )
        -> NSLayoutConstraint
    {
        let layoutConstraint = NSLayoutConstraint(
            item: from.view,
            attribute: from.attribute,
            relatedBy: relation,
            toItem: to?.view,
            attribute: to?.attribute ?? .notAnAttribute,
            multiplier: CGFloat(coefficients.multiplier),
            constant: CGFloat(coefficients.constant)
        )

        if let to = to {
            if let common = constraintsHolder(of: from.view, and: to.view ) {
                constraints.append(Constraint(holder: common, layoutConstraint: layoutConstraint))
            } else {
                fatalError("No common superview found between \(from.view) and \(to.view)")
            }
        } else {
            constraints.append(Constraint(holder: from.view, layoutConstraint: layoutConstraint))
        }

        return layoutConstraint
    }
    
    internal func addConstraint(
        from: Compound,
        to: Compound? = nil,
        coefficients: [Coefficients]? = nil,
        relation: NSLayoutRelation = .equal
        ) -> [NSLayoutConstraint]
    {
        var results: [NSLayoutConstraint] = []
        
        assert(from.properties.count == to?.properties.count || to == nil)
        assert(
            from.properties.count == coefficients?.count
                || coefficients == nil
        )
        
        for i in 0..<from.properties.count {
            
            let constraint = addConstraint(
                from: from.properties[i],
                to: to?.properties[i], 
                coefficients: coefficients?[i] ?? Coefficients(),
                relation: relation
            )
            
            results.append(constraint)
        }

        return results
    }
}
