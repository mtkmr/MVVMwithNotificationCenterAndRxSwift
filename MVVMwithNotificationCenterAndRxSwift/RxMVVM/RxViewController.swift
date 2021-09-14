//
//  RxViewController.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/09/07.
//

import UIKit
import RxSwift

class RxViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!

    //ViewModelを保持する
    private lazy var rxViewModel = RxViewModel(
        idTextObservable: idTextField.rx.text.asObservable(),
        passwordTextObservable: passwordTextField.rx.text.asObservable(),
        rxModel: RxModel())

    //購読解除のための用意
    private let disposeBag = DisposeBag()

    //UIColorを購読(ここではバインド)できるようにしておく
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.validationLabel.textColor = color
        }
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //ViewModelを通じてデータバインドし、値の更新をlabelに表示する
        //rx.textはRxCocoaの拡張機能
        rxViewModel.validationText
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)

        rxViewModel.loadLabelColor
            .bind(to: loadLabelColor)
            .disposed(by: disposeBag)
    }

}
