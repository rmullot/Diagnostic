//
//  RMTextField.swift
//  RMUI
//
//  Created by Romain Mullot on 10/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public typealias RMTextFieldClosure = ((_ text: String) -> Void)?

@IBDesignable
public class RMTextField: UIView {

    // MARK: - Private Members

    private var restoreState: Bool = false
    private let textFieldtopToolBarHeight: CGFloat = 50

    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: - Initialization & Memory Management

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override public func prepareForInterfaceBuilder() {
        initialize()
    }

    // MARK: - Public Properties

    public var didBeginEditing: RMTextFieldClosure

    public var didEndEditing: RMTextFieldClosure

    public var textDidChange: RMTextFieldClosure

    public var whichIsNextResponder: ((_ responder: UIResponder) -> UIResponder?)?

    public var isSecureTextEntry: Bool {
        get { return textField.isSecureTextEntry }
        set {
            textField.isSecureTextEntry = newValue
            if #available(iOS 11.0, *) {
                textField.textContentType = .password
            }
        }
    }

    @IBInspectable public var placeholder: String?

    public var keyboardType: UIKeyboardType {

        get { return textField.keyboardType }
        set {
            switch keyboardType {
            case .numberPad:
                addDoneButtonAccessoryView()
            case .phonePad:
                if #available(iOS 11.0, *) {
                    textField.textContentType = .telephoneNumber
                }
                addDoneButtonAccessoryView()
            case .emailAddress:
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
                textField.textContentType = .emailAddress
            default:
                break
            }
        }
    }

    public var text: String {
        get { return textField.text ?? "" }
        set {
            titleLabel.isHidden = !newValue.isEmpty
            textField.text = newValue
        }
    }

    override public var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }

    override public var accessibilityIdentifier: String? {
        get {
            return textField?.accessibilityIdentifier ?? nil
        }
        set {
            textField?.accessibilityIdentifier = newValue
        }
    }

    public var textContentType: UITextContentType? {
        get {
            return textField?.textContentType ?? nil
        }
        set {
            textField?.textContentType = newValue
        }
    }

    // MARK: - Public Methods

    public func setInvalidState() {
        setState(false)
    }

    public func setValidState() {
        setState(true)
    }

    override public func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    // MARK: - Private Methods

    /// Method creating a done button inside the inputAccessoryView
    /// - Note:
    ///   Usefull for some keyboardType where we don't have a return button to collapse the keyboard
    private func addDoneButtonAccessoryView() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: textFieldtopToolBarHeight))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonAction))

        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }

    private func initialize() {
      let bundle = Bundle(for: type(of: self))
      guard let view = UINib(nibName: "RMTextField", bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView else { return }
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.frame = bounds
      view.layer.masksToBounds = true
      view.translatesAutoresizingMaskIntoConstraints = true
      addSubview(view)

      if let placeholder = placeholder {
          textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
          titleLabel.text = placeholder
      }

      let paddingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: textField.frame.height)))
      textField.leftView = paddingView
      textField.leftViewMode = UITextField.ViewMode.always
      textField.layer.cornerRadius = 5.0
      textField.backgroundColor = UIColor.white
      textField.layer.borderColor = UIColor.black.cgColor
      textField.layer.borderWidth = 1.0
    }

    /// Method permitting to restore or not the default UI state of the texfield
    /// - Note:
    ///   True => default color (Black border)
    ///   False => regex invalid  color (Red border)
    /// - Parameters:
    ///     - isValid: Boolean changing the texfiled state
    private func setState(_ isValid: Bool) {
        restoreState = isValid
        self.textField.layer.borderColor = restoreState ? UIColor.black.cgColor : UIColor.red.cgColor
    }

}

// MARK: - UITextFieldDelegate

extension RMTextField: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string)
            restoreState = false
            if textField.textContentType == UITextContentType.emailAddress {
                textField.autocorrectionType = newText.isEmpty ? .default : .no
            }
            titleLabel.isHidden = newText.isEmpty
            textDidChange?(newText)
        }
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = canActivateNextResponder(textField) ? .next : .default
        didBeginEditing?(textField.text ?? "")
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.clearButtonMode = .never
        didEndEditing?(textField.text ?? "")
        if restoreState {
            setState(restoreState)
        }
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // The next line permits to avoid launching shouldChangeCharactersIn with a word from prediction
        text = ""
        restoreState = false
        textDidChange?("")
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Code permitting to choose the next Textfield in a form
        if let nextResponder = whichIsNextResponder != nil ? whichIsNextResponder!(self) : getNextResponder(textField) {
            if nextResponder is UITextField || nextResponder is RMTextField {
                nextResponder.becomeFirstResponder()
                return false
            }
        }

        textField.resignFirstResponder()
        return false
    }

    // MARK: - Private Methods

    /// Method returning a boolean to know if inside the form, we can move to another textfield
    /// - Parameters:
    ///     - textField: textfield to check
    /// - Returns:  A boolean to know if we can move from a texfiled to another.
    private func canActivateNextResponder(_ textField: UITextField) -> Bool {
        guard let nextResponder = whichIsNextResponder != nil ? whichIsNextResponder!(self) : getNextResponder(textField) else { return false }
        return nextResponder.canBecomeFirstResponder
    }

    /// Method which permits to obtain the next textfield base on tag key
    private func getNextResponder(_ textField: UITextField) -> UIResponder? {
        return self.superview?.viewWithTag(tag + 1)
    }

}
