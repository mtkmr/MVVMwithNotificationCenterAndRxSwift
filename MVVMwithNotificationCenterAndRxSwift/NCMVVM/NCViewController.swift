//
//  NCViewController.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/08/07.
//

import UIKit
/*
 Viewの責務
• ユーザー入力を ViewModel に伝搬する
• 自身の状態と ViewModel の状態をデータバインディングする
• ViewModel から返されるイベントを元に描画処理を実行する
*/
final class NCViewController: UIViewController {
    //notificationCenterオブジェクト
    private let notificationCenter = NotificationCenter()
    //viewModelオブジェクトを持つ
    private lazy var viewModel = NCViewModel(notificationCenter: notificationCenter)
    
    //textField２つにはaddTargetで、入力があればtextFieldEditingChanged(_:)を呼ぶように登録しておく
    @IBOutlet private weak var idTextField: UITextField! {
        didSet {
            idTextField.addTarget(self,
                                  action: #selector(textFieldEditingChanged(_:)),
                                  for: .editingChanged)
        }
    }
    
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.addTarget(self,
                                        action: #selector(textFieldEditingChanged(_:)),
                                        for: .editingChanged)
        }
    }
    
    @IBOutlet private weak var validationLabel: UILabel! {
        didSet {
            validationLabel.text = "IDとPasswordを入力してください"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenterを利用してviewModelを監視する
        //viewModelから通知がpostされるたびに呼ばれるメソッドを登録しておく
        //つまり、イベントが起きるとviewが更新できるようにしている
        notificationCenter.addObserver(self,
                                       selector: #selector(updateValidationText(notification:)),
                                       name: viewModel.changeText,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(updateValidationColor(notification:)),
                                       name: viewModel.changeColor,
                                       object: nil)
    }
}

private extension NCViewController {
    ///textFieldへのIDまたはPasswordの入力をviewModelへ伝播させる
    @objc
    private func textFieldEditingChanged(_ sender: UITextField) {
        //viewModelに通知する
        viewModel.idPasswordChanded(
            id: idTextField.text,
            password: passwordTextField.text)
    }
    
    ///NotificationCenterで監視している何らかが通知をpostしたときに呼び出され、この中で描画処理を行う
    @objc
    private func updateValidationText(notification: Notification) {
        //NotificationCenterで送られてくるデータは型情報が失われてしますのでキャストする
        //ライブラリを使用する場合は型情報が担保されている
        guard let text = notification.object as? String else { return }
        validationLabel.text = text
    }
    
    @objc
    private func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationLabel.textColor = color
    }
}
