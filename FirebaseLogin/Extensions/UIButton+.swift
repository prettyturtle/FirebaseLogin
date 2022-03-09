//
//  UIButton+.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit

extension UIButton {
    func signUpStyle() {
        self.setTitle("회원가입", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 4.0
        self.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .semibold)
        self.isEnabled = false
        self.alpha = 0.3
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
    func signInStyle() {
        self.setTitle("로그인", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 4.0
        self.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .semibold)
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
}
