//
//  MainViewModel.swift
//  FirebaseLogin
//
//  Created by yc on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class MainViewModel {
    let disposeBag = DisposeBag()
    
    let FIRAuth = Auth.auth()
    
    let currentUser = BehaviorSubject<String>(value: "로그인 정보 없음")
    let emailVerified = BehaviorSubject<Bool>(value: false)
    let didTapLogoutButton = PublishRelay<Void>()
    let pop = PublishSubject<Void>()
    
    init() {
        getCurrentUser()
        isEmailVerified()
        
        didTapLogoutButton
            .subscribe(onNext: { [weak self] _ in
                self?.logout()
                self?.pop.onNext(())
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
}
