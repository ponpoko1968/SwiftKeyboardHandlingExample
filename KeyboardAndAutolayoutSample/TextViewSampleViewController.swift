//
//  TextViewSampleViewController.swift
//  KeyboardAndAutolayoutSample
//
//  Created by 越智修司 on 2020/11/26.
//  Copyright © 2020 shuji ochi. All rights reserved.
//

import UIKit

class TextViewSampleViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomMargin: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CloseKeyboardView", bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        guard  views.count > 0, let v = views[0] as? UIView  else {
            fatalError()
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        v.addGestureRecognizer(gesture)
        textView.inputAccessoryView = v
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

@objc private func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        UIView.animate(withDuration: duration,
                       animations: {
                        self.textViewBottomMargin.constant = keyboardSize.height
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
        UIView.animate(withDuration: duration,
                       animations: {
                        self.textViewBottomMargin.constant = 0
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
        textViewBottomMargin.constant = keyboardSize.height
        view.layoutIfNeeded()
    }

    @objc private func hideKeyboard(){
        textView.resignFirstResponder()
    }

}
