//
//  SignInViewModel.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/08.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SignInViewModel {
    let disposeBag = DisposeBag()
    let FIRAuth = Auth.auth()
    let emailPasswordInput = BehaviorSubject<(email: String, password: String)>(value: (email: "", password: ""))
    let didTapSignInButton = PublishRelay<Void>()
    let err = PublishSubject<Error>()
    let successSignIn = PublishSubject<UIAlertController>()
    init() {
        didTapSignInButton
            .withLatestFrom(emailPasswordInput)
            .subscribe(onNext: { [weak self] form in
                self?.signIn(email: form.email, password: form.password)
            })
            .disposed(by: disposeBag)
    }
    func signIn(email: String, password: String) {
        FIRAuth
            .signIn(withEmail: email, password: password) { [weak self] res, error in
                guard let self = self else { return }
                if let error = error {
                    self.err.onNext(error)
                } else {
                    self.successSignIn.onNext(self.successSignInAlert())
                }
            }
    }
    func successSignInAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "로그인 성공", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
}
