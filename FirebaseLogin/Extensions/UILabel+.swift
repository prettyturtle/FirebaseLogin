//
//  UILabel+.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/08.
//

import UIKit

extension UILabel {
    func errorLabelStyle() {
        self.font = .systemFont(ofSize: 14.0, weight: .regular)
        self.textColor = .systemRed
        self.isHidden = true
        self.numberOfLines = 2
    }
}
