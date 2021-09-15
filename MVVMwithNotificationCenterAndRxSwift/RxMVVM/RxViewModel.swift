//
//  RxViewModel.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/09/07.
//

import UIKit
import RxSwift
import RxCocoa

final class RxViewModel {
    //Observableとして公開する
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>

    init(idTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         rxModel: RxModelProtocol) {
        let event = Observable
            .combineLatest(idTextObservable, passwordTextObservable) //2つのObservableを合成
            .skip(1) //最初のストリームをスキップ
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                return rxModel
                    .validate(idText: idText, passwordText: passwordText)
                    .materialize()
            }
            .share() //リソースを共有できる = 一つのストリームで複数の購読者に対応できる

        self.validationText = event
            .flatMap({ event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK!!!")
                case let .error(error as RxModelError):
                    return .just(error.description)
                case .error, .completed:
                    return .empty()
                }
            })
            .startWith("IDとPasswordを入力してください。")

        self.loadLabelColor = event
            .flatMap({ event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error:
                    return .just(.red)
                case .completed:
                    return .empty()
                }
            })
    }
}
