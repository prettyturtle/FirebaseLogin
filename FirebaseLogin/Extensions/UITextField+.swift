//
//  UITextField.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit

extension UITextField {
    func emailForm() {
        self.placeholder = "이메일을 입력하세요."
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 16.0, weight: .medium)
        self.autocapitalizationType = .none
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
    func passwordForm() {
        self.placeholder = "비밀번호를 입력하세요.(6자 이상)"
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 16.0, weight: .medium)
        self.autocapitalizationType = .none
        self.isSecureTextEntry = true
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
}
