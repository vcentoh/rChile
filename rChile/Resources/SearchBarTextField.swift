//
//  SearchBarTextField.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import UIKit

class SearchBarTextField: UITextField {
    private var enableCopyPasteAssociationKey = ""

    override var placeholder: String? {
        didSet {
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
            ]
            let placeholderString = NSAttributedString(string: placeholder ?? "", attributes: attributes)
            self.attributedPlaceholder = placeholderString
        }
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0))
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0))
    }

    var isEnableCopyPaste: Bool {
        get {
            return objc_getAssociatedObject(self, &enableCopyPasteAssociationKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &enableCopyPasteAssociationKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(paste(_:)), #selector(copy(_:)):
            return isEnableCopyPaste
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
}
