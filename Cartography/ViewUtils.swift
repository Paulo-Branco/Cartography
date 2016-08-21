//
//  ViewUtils.swift
//  Cartography
//
//  Created by Garth Snyder on 11/23/14.
//  Copyright (c) 2014 Manfred Lau. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

import SwiftExt

internal func constraintsHolder(of a: View, and b: View) -> View? {
    var checkedViewsAlongAToSuper = [ObjectIdentifier: View]()
    var checkedViewsAlongBToSuper = [ObjectIdentifier: View]()
    
    let viewsAlongAToSuper = _viewsAlongItToSuper(a).makeIterator()
    let viewsAlongBToSuper = _viewsAlongItToSuper(b).makeIterator()
    
    var continueSearching = true
    
    // We cannot simply zip two streams here because they may be in
    // different length.
    while continueSearching {
        continueSearching = false
        
        // O(N * lgM)
        if let aViewAlongAToSuper = viewsAlongAToSuper.next() {
            let viewId = ObjectIdentifier(aViewAlongAToSuper)
            
            if checkedViewsAlongBToSuper[viewId] != nil {
                return aViewAlongAToSuper
            } else {
                checkedViewsAlongAToSuper[viewId] = aViewAlongAToSuper
            }
            continueSearching = continueSearching || true
        }
        
        // O(M * lgN)
        if let aViewAlongBToSuper = viewsAlongBToSuper.next() {
            let viewId = ObjectIdentifier(aViewAlongBToSuper)
            
            if checkedViewsAlongAToSuper[viewId] != nil {
                return aViewAlongBToSuper
            } else {
                checkedViewsAlongBToSuper[viewId] = aViewAlongBToSuper
            }
            continueSearching = continueSearching || true
        }
    }
    
    return nil
}

private func _viewsAlongItToSuper(_ v: View) -> AnySequence<View> {
    return AnySequence { () -> AnyIterator<View> in
        var view: View? = v
        return AnyIterator {
            let current = view
            view = view?.superview
            return current
        }
    }
}
