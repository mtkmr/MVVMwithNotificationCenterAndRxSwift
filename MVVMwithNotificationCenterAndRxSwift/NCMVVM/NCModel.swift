//
//  NCModel.swift
//  MVVMwithNotificationCenterAndRxSwift
//
//  Created by Masato Takamura on 2021/08/07.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum NCModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

extension NCModelError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidId:
            return "IDが未入力です"
        case .invalidPassword:
            return "Passwordが未入力です"
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です"
        }
    }
}

///ドメインロジック
protocol NCModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Result<Void>
}

final class NCModel {}

extension NCModel: NCModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Result<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return .failure(NCModelError.invalidIdAndPassword)
        case (.none, .some):
            return .failure(NCModelError.invalidId)
        case (.some, .none):
            return .failure(NCModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return .failure(NCModelError.invalidIdAndPassword)
            case (true, false):
                return .failure(NCModelError.invalidId)
            case (false, true):
                return .failure(NCModelError.invalidPassword)
            case (false, false):
                return .success(())
            }
        }
    }
    
    
}
