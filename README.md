# 파이어베이스를 이용한 회원가입, 로그인, 로그아웃, 인증 메일 전송 구현하기
## rx, MVVM practice

### Library
 - RxSwift
 - RxCocoa
 - SnapKit
 - FirebaseAuth

### 회원가입
- `createUser` 메서드를 사용하면 간단하게 구현할 수 있다
- 에러가 났다면 그 에러를 표시하고
  - 에러의 예: 입력한 이메일의 형식이 맞지 않음, 비밀번호의 길이가 6자리 이상이 아님, 이미 존재하는 이메일임 등
  - 발생한 에러를 `NSError`로 타입캐스팅 하여 에러 코드를 확인할 수 있다
- 에러가 나지 않았다면 회원가입에 성공한 것이다
  - 회원가입에 성공했다면 자동적으로 로그인이 되는 것을 확인했다
``` swift
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

Auth.auth()
    .createUser(withEmail: email, password: password) { [weak self] res, error in
        guard let self = self else { return }
        if let error = error {
            // 에러가 났다면 여기서 처리 ...
            self.err.onNext(error)
        } else {
            // 회원가입에 성공했다면 여기서 처리...
            self.signUpSuccess.onNext(self.signUpSuccessAlert())
        }
    }
```

### 로그인
- `signIn` 메서드를 사용하면 간단하게 구현할 수 있다
- 회원가입에서 했던 것과 비슷하게
- 로그인 중 에러가 발생했다면 에러를 표시하고
- 에러가 나지 않았다면 로그인에 성공한 것이다

``` swift
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

Auth.auth()
     .signIn(withEmail: email, password: password) { [weak self] res, error in
        guard let self = self else { return }
        if let error = error {
            // 에러가 났다면 여기서 처리 ...
            self.err.onNext(error)
        } else {
            // 로그인에 성공했다면 여기서 처리...
            self.successSignIn.onNext(self.successSignInAlert())
        }
    }
```

### 로그아웃
- `signOut` 메서드를 사용하면 정말 간단하게 구현할 수 있다
- 이 메서드는 에러를 방출하므로
- do-catch 문으로 예외처리를 해주면 된다

``` swift
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

do {
    try FIRAuth.signOut()
} catch {
    print("-----SignOut ERROR-----")
}
```

### 인증 메일 전송
1. 이메일 인증이 되어있는지 확인하기
``` swift
Auth.auth().currentUser?.isEmailVerified // true or false
```
2. 이메일 인증 메일 보내기
    - `sendEmailVerification` 메서드를 사용하자
    - 회원가입, 로그인과 동일한 방법으로 사용하면 된다
    - 이메일 인증 메일 전송을 하면 가입한 이메일로 전송이 된다
    
``` swift
Auth.auth()
    .currentUser?
    .sendEmailVerification(completion: { [weak self] error in
        guard let self = self else { return }
        if let error = error {
            // 에러가 났다면 여기서 처리 ...
            print("-----Verify Email ERROR \(error.localizedDescription)-----")
        } else {
            // 이메일 전송에 성공했다면 여기서 처리...
            self.showAlert.onNext(self.showSendEmailAlert())
        }
    }
```
