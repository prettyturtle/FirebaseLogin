//
//  SignUpViewModel.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/08.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewModel {
    let disposeBag = DisposeBag()
    
    let FIRAuth = Auth.auth()
    
    let emailValid = BehaviorSubject<Bool>(value: false)
    let passwordValid = BehaviorSubject<Bool>(value: false)
    let emailPasswordInput = BehaviorSubject<(email: String, password: String)>(value: (email: "", password: ""))
    let didTapSignUpButton = PublishRelay<Void>()
    let err = PublishSubject<Error>()
    let signUpSuccess = PublishSubject<UIAlertController>()
    
    func isEmailValid(_ email: String) -> Bool {
        if email.contains("@") && email.contains(".") {
            return true
        } else {
            return false
        }
    }
    
    func isPasswordValid(_ pw: String) -> Bool {
        if pw.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    func signUp(email: String, password: String) {
        FIRAuth
            .createUser(withEmail: email, password: password) { [weak self] res, error in
                guard let self = self else { return }
                if let error = error {
                    self.err.onNext(error)
                } else {
                    //                    self.signUpSuccess.onNext("회원가입 성공")
                    self.signUpSuccess.onNext(self.signUpSuccessAlert())
                }
            }
    }
    func signUpSuccessAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "회원가입 성공", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
    
    init() {
        didTapSignUpButton
            .withLatestFrom(emailPasswordInput)
            .subscribe(onNext: { [weak self] form in
                self?.signUp(email: form.email, password: form.password)
            })
            .disposed(by: disposeBag)
    }
}
