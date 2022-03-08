//
//  SignUpViewController.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let FIRAuth = Auth.auth()
    let emailValid = BehaviorSubject<Bool>(value: false)
    let passwordValid = BehaviorSubject<Bool>(value: false)
    let emailPasswordInput = BehaviorSubject<(String, String)>(value: ("", ""))
    
    let err = PublishSubject<Error>()
    let signUpSuccess = PublishSubject<String>()
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signUpButton = UIButton()
    private let signInButton = UIButton()
    private let errorLabel = UILabel()
    private let emailValidBullet = UIView()
    private let passwordValidBullet = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupAttribute()
        bind()
    }
}

private extension SignUpViewController {
    func bind() {
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let signInVC = SignInViewController()
                self?.show(signInVC, sender: nil)
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .withLatestFrom(passwordTextField.rx.text.orEmpty) {($0, $1)}
            .bind(to: emailPasswordInput)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .withLatestFrom(emailTextField.rx.text.orEmpty) {($1, $0)}
            .bind(to: emailPasswordInput)
            .disposed(by: disposeBag)

        emailPasswordInput
            .map { $0.0 }
            .map(isEmailValid)
            .bind(to: emailValid)
            .disposed(by: disposeBag)
        
        emailPasswordInput
            .map { $0.1 }
            .map(isPasswordValid)
            .bind(to: passwordValid)
            .disposed(by: disposeBag)
        
        emailValid
            .bind(to: emailValidBullet.rx.isHidden)
            .disposed(by: disposeBag)
        passwordValid
            .bind(to: passwordValidBullet.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                emailValid,
                passwordValid
            ) { $0 && $1 }
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        Observable
            .combineLatest(
                emailValid,
                passwordValid
            ) { $0 && $1 ? 1.0 : 0.3 }
            .bind(to: signUpButton.rx.alpha)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .withLatestFrom(emailPasswordInput)
            .subscribe(onNext: { [weak self] k in
                self?.signUp(email: k.0, password: k.1)
            })
            .disposed(by: disposeBag)
        
        err
            .map { $0.localizedDescription }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        err
            .map { _ in false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        signUpSuccess
            .subscribe(onNext: {
                let alertController = UIAlertController(title: $0, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    let signInVC = SignInViewController()
                    self.show(signInVC, sender: nil)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func signUp(email: String, password: String) {
        FIRAuth.createUser(withEmail: email, password: password) { [weak self] res, error in
            guard let self = self else { return }
            if let error = error {
                self.err.onNext(error)
            } else {
                self.signUpSuccess.onNext("회원가입 성공")
            }
        }
    }
    
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
    
    func setupAttribute() {
        emailTextField.emailForm()
        passwordTextField.passwordForm()
        signUpButton.signUpStyle()
        signInButton.setTitle("로그인", for: .normal)
        signInButton.setTitleColor(.secondaryLabel, for: .normal)
        errorLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 2
        
        [
            emailValidBullet,
            passwordValidBullet
        ].forEach { bullet in
            bullet.backgroundColor = .systemRed
            bullet.layer.cornerRadius = 4.0
            bullet.snp.makeConstraints { $0.size.equalTo(8.0) }
        }
    }
    func setupLayout() {
        [
            emailTextField,
            passwordTextField,
            errorLabel,
            emailValidBullet,
            passwordValidBullet,
            signUpButton,
            signInButton
        ].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(16.0)
        }
        emailValidBullet.snp.makeConstraints {
            $0.centerY.equalTo(emailTextField.snp.centerY)
            $0.trailing.equalTo(emailTextField.snp.trailing).inset(8.0)
        }
        passwordValidBullet.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField.snp.centerY)
            $0.trailing.equalTo(passwordTextField.snp.trailing).inset(8.0)
        }
    }
    func setupNavigationBar() {
        title = "회원가입"
    }
}
