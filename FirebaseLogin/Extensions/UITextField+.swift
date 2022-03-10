//
//  UITextField.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit

extension UITextField {
    enum Style {
        case email
        case password
        case name
    }
    func defaultForm(_ placeholder: String, style: Style) {
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 16.0, weight: .medium)
        self.autocapitalizationType = .none
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        switch style {
        case .password:
            self.isSecureTextEntry = true
        case .email, .name:
            break
        }
    }
}
