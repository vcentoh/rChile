//
//  UIView+Extension.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import UIKit

// MARK: - Shadows and Corners
extension UIView {
    
    func setupRoundedCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func setupBorder(width: CGFloat = 1.0, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func makeItCircular() {
        layoutIfNeeded()
        setupRoundedCorners(radius: min(frame.size.height, frame.size.width) / 2)
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraintsToFit(view: self)
    }
    
    func addConstraintsToFit(view: UIView) {
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 options: NSLayoutConstraint.FormatOptions(),
                                                                 metrics: nil,
                                                                 views: ["view": view])
        addConstraints(verticalConstraints)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: NSLayoutConstraint.FormatOptions(),
                                                                   metrics: nil,
                                                                   views: ["view": view])
        addConstraints(horizontalConstraints)
    }
}
