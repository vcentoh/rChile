//
//  SearchBarAction.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import RxSwift

public typealias SearchBarAction = (
    didTap: Observable<Void>,
    editingDidBegin: Observable<Void>,
    editingDidEnd: Observable<Void>,
    text: Observable<String>,
    didSearch: Observable<String>
)

/// UI component that represent a search bar view
public protocol SearchBarComponentProtocol {
    // Group of actions to subscribe
    var actions: SearchBarAction { get }
    // Current text of search text field
    var text: String? { get set }
    // Current placeholder of search text field
    var placeholder: String? { get set }
    // Work how search bar or search button bar
    var isSearchMode: Bool { get set }
    // Set your custom delegate to search text field component
    var delegate: UITextFieldDelegate? { get set }
    // Become first responder of search text field component
    func becomeFirstResponder()
    // Resign first responder of search text field component
    func resignFirstResponder()
    // Select all content of search text field component
    func selectAll(_ sender: Any?)
}
