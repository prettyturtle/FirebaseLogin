//
//  MainViewController.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    let mainViewModel = MainViewModel()
    
    private let userNameLabel = UILabel()
    private let emailVerifiedLabel = UILabel()
    private let emailVerifyButton = UIButton()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        bind(viewModel: mainViewModel)
    }
    func bind(viewModel: MainViewModel) {
        logoutButton.rx.tap
            .bind(to: viewModel.didTapLogoutButton)
            .disposed(by: disposeBag)
        
        viewModel.currentUser
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.emailVerified
            .map { !$0 }
            .bind(to: emailVerifyButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.emailVerified
            .map { $0 ? 0.3 : 1.0 }
            .bind(to: emailVerifyButton.rx.alpha)
            .disposed(by: disposeBag)
        viewModel.emailVerified
            .map { $0 ? "인증 완료" : "미인증" }
            .bind(to: emailVerifiedLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.pop
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

private extension MainViewController {
    func setupAttribute() {
        view.backgroundColor = .systemBackground
        emailVerifyButton.defaultStyle("이메일 인증")
        logoutButton.defaultStyle("로그아웃")
        logoutButton.backgroundColor = .systemRed
    }
    func setupLayout() {
        [
            userNameLabel,
            emailVerifiedLabel,
            emailVerifyButton,
            logoutButton
        ].forEach { view.addSubview($0) }
        userNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        emailVerifiedLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(16.0)
            $0.centerX.equalTo(userNameLabel)
        }
        emailVerifyButton.snp.makeConstraints {
            $0.top.equalTo(emailVerifiedLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(emailVerifyButton.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
}
