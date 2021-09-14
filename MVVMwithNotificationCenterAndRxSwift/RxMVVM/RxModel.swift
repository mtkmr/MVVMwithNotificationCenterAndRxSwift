//
//  RxModel.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/09/07.
//

import RxSwift
//import RxCocoa

enum RxModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword

    var description: String {
        switch self {
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です。"
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        }
    }
}

//プロトコルにしてViewModelとの疎結合を保つ
protocol RxModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

final class RxModel: RxModelProtocol {
    ///呼び出し元でObservableとして扱えるようにObservableを返す
    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(RxModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(RxModelError.invalidId)
        case (.some, .none):
            return Observable.error(RxModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return Observable.error(RxModelError.invalidIdAndPassword)
            case (false, false):
                return Observable.just(())
            case (true, false):
                return Observable.error(RxModelError.invalidId)
            case (false, true):
                return Observable.error(RxModelError.invalidPassword)
            }
        }
    }

    
}
