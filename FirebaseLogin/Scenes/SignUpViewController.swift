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

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let signUpViewModel = SignUpViewModel()
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let nameTextField = UITextField()
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
        bind(viewModel: signUpViewModel)
    }
    func bind(viewModel: SignUpViewModel) {
        emailTextField.rx.text.orEmpty
            .map(viewModel.isEmailValid)
            .bind(to: viewModel.emailValid)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .map(viewModel.isPasswordValid)
            .bind(to: viewModel.passwordValid)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                emailTextField.rx.text.orEmpty,
                passwordTextField.rx.text.orEmpty,
                nameTextField.rx.text.orEmpty
            ) { (email: $0, password: $1, name: $2) }
            .bind(to: viewModel.textInput)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                viewModel.emailValid,
                viewModel.passwordValid
            ) { $0 && $1 }
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                viewModel.emailValid,
                viewModel.passwordValid
            ) { $0 && $1 ? 1.0 : 0.3 }
            .bind(to: signUpButton.rx.alpha)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let signInVC = SignInViewController()
                self?.show(signInVC, sender: nil)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(to: viewModel.didTapSignUpButton)
            .disposed(by: disposeBag)
        
        viewModel.emailValid
            .bind(to: emailValidBullet.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.passwordValid
            .bind(to: passwordValidBullet.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.err
            .map { $0.localizedDescription }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.err
            .map { _ in false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.signUpSuccess
            .subscribe(onNext: { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

private extension SignUpViewController {
    func setupAttribute() {
        emailTextField.defaultForm("이메일을 입력하세요.", style: .email)
        passwordTextField.defaultForm("비밀번호를 입력하세요.(6자 이상)", style: .password)
        nameTextField.defaultForm("이름을 입력하세요.", style: .name)
        signUpButton.defaultStyle("회원가입")
        signInButton.setTitle("로그인", for: .normal)
        signInButton.setTitleColor(.secondaryLabel, for: .normal)
        errorLabel.errorLabelStyle()
        
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
            nameTextField,
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
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16.0)
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
