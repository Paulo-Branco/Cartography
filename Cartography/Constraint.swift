//
//  Constraint.swift
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

final internal class Constraint: NSObject, NSCoding {
    // Set to weak to avoid a retain cycle on the associated view.
    internal weak var holder: View?
    internal private(set) var layoutConstraint: NSLayoutConstraint!

    internal func install() {
        holder?.addConstraint(layoutConstraint)
    }

    internal func uninstall() {
        holder?.removeConstraint(layoutConstraint)
    }

    internal init(holder: View?, layoutConstraint: NSLayoutConstraint) {
        self.holder = holder
        self.layoutConstraint = layoutConstraint
        super.init()
    }
    
    //MARK: NSCoding Support
    internal init?(coder aDecoder: NSCoder) {
        super.init()
        if aDecoder.containsValue(forKey: "holder")
            && aDecoder.containsValue(forKey: "layoutConstraint")
        {
            holder = aDecoder.decodeObject(forKey: "holder") as? View
            layoutConstraint = aDecoder.decodeObject(forKey: "layoutConstraint")
                as? NSLayoutConstraint
        } else {
            return nil
        }
    }
    
    internal func encode(with aCoder: NSCoder) {
        aCoder.encode(holder, forKey: "holder")
        aCoder.encode(layoutConstraint, forKey: "layoutConstraint")
    }
}
