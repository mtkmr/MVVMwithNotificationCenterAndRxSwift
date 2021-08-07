//
//  NCViewModel.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/08/07.
//

import UIKit

/*
 ViewModelの責務
 • View に表示するためのデータを保持する 今回は保持する必要がないので出てこないが。
 • View からイベントを受け取り、Model の処理を呼び出す
 • View からイベントを受け取り、加工して値を更新する
 */
final class NCViewModel {
    let changeText = Notification.Name("changeText")
    let changeColor = Notification.Name("changeColor")
    
    private let notificationCenter: NotificationCenter
    //modelを疎結合で保持する
    private let ncModel: NCModelProtocol
    
    init(notificationCenter: NotificationCenter, model: NCModelProtocol = NCModel()) {
        self.notificationCenter = notificationCenter
        self.ncModel = model
    }
    
    ///view側で呼ばれる
    func idPasswordChanded(id: String?, password: String?) {
        //modelを呼び出してバリデーション結果を受け取る
        let result = ncModel.validate(idText: id, passwordText: password)
        //modelによる処理結果を加工してNotificationCenterのpostによって通知する
        //→監視しているViewに伝わる
        switch result {
        case .failure(let error as NCModelError):
            notificationCenter.post(name: changeText, object: error.description)
            notificationCenter.post(name: changeColor, object: UIColor.red)
        case .success:
            notificationCenter.post(name: changeText, object: "OK👍")
            notificationCenter.post(name: changeColor, object: UIColor.green)
        default:
            fatalError("Unexpected error")
        }
        
    }
}
