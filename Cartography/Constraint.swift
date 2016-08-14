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
    weak var view: View?
    private(set) var layoutConstraint: NSLayoutConstraint!

    func install() {
        view?.addConstraint(layoutConstraint)
    }

    func uninstall() {
        view?.removeConstraint(layoutConstraint)
    }

    init(view: View?, layoutConstraint: NSLayoutConstraint) {
        self.view = view
        self.layoutConstraint = layoutConstraint
        super.init()
    }
    
    //MARK: NSCoding Support
    init?(coder aDecoder: NSCoder) {
        super.init()
        if aDecoder.containsValue(forKey: "view")
            && aDecoder.containsValue(forKey: "layoutConstraint")
        {
            view = aDecoder.decodeObject(forKey: "view") as? View
            layoutConstraint = aDecoder.decodeObject(forKey: "layoutConstraint")
                as? NSLayoutConstraint
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(view, forKey: "view")
        aCoder.encode(layoutConstraint, forKey: "layoutConstraint")
    }
}
