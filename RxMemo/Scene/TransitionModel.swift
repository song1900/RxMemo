//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 송우진 on 2021/05/11.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}


enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
