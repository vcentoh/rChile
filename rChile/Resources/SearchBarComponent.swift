//
//  SearchBarComponent.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import RxSwift
import RxCocoa

public final class SearchBarComponent: SearchBarComponentProtocol {
    private var component: SearchBarView

    public var base: UIView {
        return component
    }

    public var actions: SearchBarAction {
        return (
            didTap: component.didTapObservable,
            editingDidBegin: component.editingDidBeginObservable,
            editingDidEnd: component.editingDidEndObservable,
            text: component.textObservable,
            didSearch: component.didSearchObservable
        )
    }

    public var placeholder: String? {
        get {
            return component.placeholder
        }
        set {
            component.placeholder = newValue
        }
    }

    public var text: String? {
        get {
            return component.text
        }
        set {
            component.text = newValue
        }
    }

    public var isSearchMode: Bool {
        get {
            return component.isSearchMode
        } set {
            component.isSearchMode = newValue
        }
    }

    public var delegate: UITextFieldDelegate? {
        get {
            return component.searchTextField.delegate
        } set {
            component.searchTextField.delegate = newValue
        }
    }

    public var isEnableCopyPaste: Bool {
        get {
            return component.isEnableCopyPaste
        } set {
            component.isEnableCopyPaste = newValue
        }
    }

    public init (frame: CGRect) {
        component = SearchBarView(frame: frame)
    }

    public func becomeFirstResponder() {
        component.searchTextField.becomeFirstResponder()
    }

    public func resignFirstResponder() {
        component.searchTextField.resignFirstResponder()
    }

    public func selectAll(_ sender: Any?) {
        component.searchTextField.selectAll(sender)
    }

    public func layoutChanges() {
        component.layoutIfNeeded()
    }
}
