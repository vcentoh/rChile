//
//  SearchBarView.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SearchBarView: UIView, UITextFieldDelegate {

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

    private enum CurrentState {
        case typing
        case empty
        case main

        var isActive: Bool {
            return self == .typing || self == .empty
        }
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setupRoundedCorners(radius: 16.0)
        return view
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()

    private lazy var searchView: SearchBarImageView = {
        let view = SearchBarImageView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var openButton: UIButton = {
        let button = UIButton()
        return button
    }()

    lazy var searchTextField: SearchBarTextField = {
        let textField = SearchBarTextField()
        textField.backgroundColor = UIColor.white
        textField.accessibilityLabel = "searchTextField"
        textField.textInputView.sizeToFit()
        textField.returnKeyType = .search
        textField.delegate = self
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.textColor = UIColor.black
        textField.font = UIFont.italicSystemFont(ofSize: 16)
        textField.tintColor = UIColor.red
        return textField
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        containerView.addGestureRecognizer(gesture)
        return gesture
    }()

    private let disposeBag = DisposeBag()
    private let searchButtonWidth: CGFloat = 48
    private let clearButtonWidth: CGFloat = 32
    private let openSubject: PublishSubject<Void> = PublishSubject<Void>()
    private let searchRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private let clearRelay: PublishRelay<Void> = PublishRelay<Void>()
    private var currentState: CurrentState = .main

    var isSearchMode: Bool = true {
        didSet {
            searchTextField.isEnabled = isSearchMode
        }
    }

    var isEnableCopyPaste: Bool {
        get { searchTextField.isEnableCopyPaste }
        set { searchTextField.isEnableCopyPaste = newValue }
    }

    var editingDidBeginObservable: Observable<Void> {
        return searchTextField.rx.controlEvent([.editingDidBegin]).asObservable().share()
    }

    var editingDidEndObservable: Observable<Void> {
        return searchTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).asObservable().share()
    }

    var textObservable: Observable<String> {
        let text = searchTextField.rx.text.orEmpty.asObservable().share()
        let clear = clearRelay.map { "" }
        return Observable.of(text, clear).merge()
    }

    var didTapObservable: Observable<Void> {
        return openSubject.asObservable().share()
    }

    var didSearchObservable: Observable<String> {
        return searchRelay.skip(1).asObservable().share()
    }

    var placeholder: String? {
        get {
            return searchTextField.placeholder
        }
        set {
            searchTextField.placeholder = newValue
        }
    }

    var text: String? {
        get {
            return searchTextField.text
        }
        set {
            searchTextField.text = newValue
            searchTextField.sendActions(for: .valueChanged)
            configureSearchView(for: newValue?.isEmpty ?? true ? .empty : .typing)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.addSubview(containerView)
        containerView.addSubview(searchTextField)
        containerView.addSubview(searchView)
        containerView.addSubview(clearButton)
        setConstraints()
        bindAction()
        tapGesture.isEnabled = true
    }

    private func setConstraints() {
        setContainerConstraints()
        setSearchButtonConstraints()
        setClearButtonConstraints()
        setSearchTextFieldConstraints()
    }

    @objc
    func onTap() {
        if isSearchMode && !searchTextField.isFirstResponder {
            searchTextField.becomeFirstResponder()
        } else if !isSearchMode {
            openSubject.onNext(())
        }
    }
    
//MARK: Search and Buttons Action
    private func bindAction() {
        clearButton.rx.tap
            .throttle(.milliseconds(5), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.currentState = .empty
                self.clearRelay.accept(())
                self.searchTextField.text = ""
                self.animateClearButton(show: false, delay: 0.0)
                self.searchTextField.becomeFirstResponder()
            }).disposed(by: disposeBag)

        editingDidBeginObservable
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let state: CurrentState = (self.searchTextField.text?.isEmpty ?? true) ? .empty : .typing
                self.configureSearchView(for: state)
            }).disposed(by: disposeBag)

        editingDidEndObservable
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let state: CurrentState = (self.searchTextField.text?.isEmpty ?? true) ? .main : .typing
                self.configureSearchView(for: state)
            }).disposed(by: disposeBag)

        searchTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.searchRelay.accept(self.searchTextField.text ?? "")
            }).disposed(by: disposeBag)

        textObservable
            .subscribe(onNext: { [weak self] text in
                guard let self = self, self.searchTextField.isEditing else { return }
                let state: CurrentState = text.isEmpty ? .empty : .typing
                self.configureSearchView(for: state)
            }).disposed(by: disposeBag)
    }

    private func setupClearButton() {
        let image = UIImage(named: "filled_close")?.withRenderingMode(.alwaysOriginal)
        clearButton.makeItCircular()
        clearButton.setImage(image, for: .normal)
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        clearButton.alpha = 0.0
        clearButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    }

    private func configureSearchView(for state: CurrentState) {
        guard state != currentState else { return }
        let animation = state.isActive ? UIView.AnimationOptions.curveEaseOut : UIView.AnimationOptions.curveEaseIn
        currentState = state
        modifySearchButton(for: state)
        UIView.animate(withDuration: 0.25, delay: 0, options: animation) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }

    private func modifySearchButton(for state: CurrentState) {
        switch state {
        case .typing:
            animateClearButton(show: true, delay: 0.0)
            animateSearchView(show: false, delay: 0.0)
        case .main:
            animateClearButton(show: false, delay: 0.0)
            animateSearchView(show: true, delay: 0.15)
        case .empty:
            animateClearButton(show: false, delay: 0.0)
            animateSearchView(show: false, delay: 0.0)
        }
    }
}

// MARK: - Animations
private extension SearchBarView {

    // MARK: - searchView
    func animateSearchView(show: Bool, delay: TimeInterval) {
        let translationX = searchButtonWidth + 4
        UIView.animate(withDuration: 0.15, delay: delay, options: .curveEaseInOut, animations: { [weak self] in
            self?.searchView.transform = show ? .identity : CGAffineTransform(translationX: translationX, y: 0)
            self?.searchView.alpha = show ? 1.0 : 0.0
        })
    }

    // MARK: - clearButton
    func animateClearButton(show: Bool, delay: TimeInterval) {
        UIView.animate(withDuration: 0.15, delay: delay, options: .curveEaseInOut, animations: { [weak self] in
            self?.clearButton.transform = show ? .identity : CGAffineTransform(scaleX: 0.3, y: 0.3)
            self?.clearButton.alpha = show ? 1.0 : 0.0
            self?.clearButton.isEnabled = show
        })
    }
}

// MARK: - Constraints
private extension SearchBarView {

    // MARK: - Container View
    func setContainerConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1).isActive = true
    }

    // MARK: - searchButton
    func setSearchButtonConstraints() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.widthAnchor.constraint(equalToConstant: searchButtonWidth).isActive = true
        searchView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4).isActive = true
        searchView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        searchView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
    }

    // MARK: - clearButton
    func setClearButtonConstraints() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.widthAnchor.constraint(equalToConstant: clearButtonWidth).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: clearButtonWidth).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }

    // MARK: - searchTextField
    func setSearchTextFieldConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: -4).isActive = true
        searchTextField.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor, multiplier: 1).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: containerView.frame.height).isActive = true
    }
}
