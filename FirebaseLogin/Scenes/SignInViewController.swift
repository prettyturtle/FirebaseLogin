//
//  SignInViewController.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    let disposeBag = DisposeBag()
    let signInViewModel = SignInViewModel()
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorLabel = UILabel()
    private let signInButton = UIButton()
    private let rightBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupAttribute()
        bind(viewModel: signInViewModel)
    }
    
    func bind(viewModel: SignInViewModel) {
        emailTextField.rx.text.orEmpty
            .withLatestFrom(passwordTextField.rx.text.orEmpty) { (email: $0, password: $1) }
            .bind(to: viewModel.emailPasswordInput)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .withLatestFrom(emailTextField.rx.text.orEmpty) { (email: $1, password: $0) }
            .bind(to: viewModel.emailPasswordInput)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(to: viewModel.didTapSignInButton)
            .disposed(by: disposeBag)
        
        rightBarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let mainVC = MainViewController()
                self?.show(mainVC, sender: nil)
            })
            .disposed(by: disposeBag)
            
        
        viewModel.err
            .map { $0.localizedDescription }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.err
            .map { _ in false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.successSignIn
            .subscribe(onNext: { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        viewModel.moveToMainVC
            .subscribe(onNext: { [weak self] _ in
                let mainVC = MainViewController()
                self?.show(mainVC, sender: nil)
            })
            .disposed(by: disposeBag)
    }
}

private extension SignInViewController {
    func setupAttribute() {
        view.backgroundColor = .systemBackground
        emailTextField.emailForm()
        passwordTextField.passwordForm()
        signInButton.defaultStyle("로그인")
        errorLabel.errorLabelStyle()
        rightBarButton.image = UIImage(systemName: "house")
    }
    func setupLayout() {
        [
            emailTextField,
            passwordTextField,
            errorLabel,
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
        signInButton.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    func setupNavigationBar() {
        title = "로그인"
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
