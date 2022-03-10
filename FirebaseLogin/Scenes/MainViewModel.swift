//
//  MainViewModel.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class MainViewModel {
    let disposeBag = DisposeBag()
    
    let FIRAuth = Auth.auth()
    
    let currentUser = BehaviorSubject<String>(value: "로그인 정보 없음")
    let emailVerified = BehaviorSubject<Bool>(value: false)
    let didTapLogoutButton = PublishRelay<Void>()
    let didTapEmailVerifyButton = PublishRelay<Void>()
    let pop = PublishSubject<Void>()
    let showAlert = PublishSubject<UIAlertController>()
    
    init() {
        getCurrentUser()
        isEmailVerified()
        
        didTapLogoutButton
            .subscribe(onNext: { [weak self] _ in
                self?.logout()
                self?.pop.onNext(())
            })
            .disposed(by: disposeBag)
        didTapEmailVerifyButton
            .subscribe(onNext: { [weak self] _ in
                self?.verifyEmail()
            })
            .disposed(by: disposeBag)
    }
    func getCurrentUser() {
        let user = FIRAuth.currentUser?.email ?? "로그인 정보 없음"
        currentUser.onNext(user)
    }
    func isEmailVerified() {
        let valid = FIRAuth.currentUser?.isEmailVerified ?? false
        emailVerified.onNext(valid)
    }
    func logout() {
        do {
            try FIRAuth.signOut()
        } catch {
            print("-----SignOut ERROR-----")
        }
    }
    func verifyEmail() {
        FIRAuth.currentUser?.sendEmailVerification(completion: { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("-----Verify Email ERROR \(error.localizedDescription)-----")
            } else {
                self.showAlert.onNext(self.showSendEmailAlert())
            }
        })
    }
    func showSendEmailAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "인증 메일 전송", message: "메일함을 확인하세요.", preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(alertAction)
        return alertController
    }
}
