//
//  TextFieldSampleViewController.swift
//  KeyboardAndAutolayoutSample
//
//  Created by 越智修司 on 2020/11/26.
//  Copyright © 2020 shuji ochi. All rights reserved.
//

import UIKit

class TextFieldSampleViewController: UIViewController {
    let defaultTextFieldBottomMargin: CGFloat = 44
    @IBOutlet var textFieldBottomMargin: NSLayoutConstraint!
    @IBOutlet var tapGestureToEndEditing: UITapGestureRecognizer!

    @IBOutlet weak var viewToBeHidden: UIView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldBottomMargin.constant = defaultTextFieldBottomMargin
        tapGestureToEndEditing.addTarget(self, action: #selector(hideKeyboard))
        textField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc private func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        viewToBeHidden.isHidden = true
        let keyboardSize = keyboardInfo.cgRectValue.size
        UIView.animate(withDuration: duration,
                       animations: {
                        self.textFieldBottomMargin.constant = keyboardSize.height + self.defaultTextFieldBottomMargin
                           self.view.layoutIfNeeded()
                       },
                       completion: {
                           _ in
        })
    }

    @objc private func keyboardDidShow(_ notification: Notification) {}

    @objc private func keyboardWillHide(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        viewToBeHidden.isHidden = false
        UIView.animate(withDuration: duration,
                       animations: {
                        self.textFieldBottomMargin.constant = self.defaultTextFieldBottomMargin
                           self.view.layoutIfNeeded()
                       },
                       completion: {
                           _ in
        })
    }
    @objc private func keyboardWillChangeFrame(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
                return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        textFieldBottomMargin.constant = self.defaultTextFieldBottomMargin + keyboardSize.height
        view.layoutIfNeeded()
    }

    @objc private func hideKeyboard(){
        textField.resignFirstResponder()
    }
}

extension TextFieldSampleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
