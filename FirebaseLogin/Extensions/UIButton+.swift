//
//  UIButton+.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit

extension UIButton {
    func defaultStyle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 4.0
        self.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .semibold)
        self.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
}
