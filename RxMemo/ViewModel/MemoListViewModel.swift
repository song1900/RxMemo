//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 송우진 on 2021/05/10.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    
    
}
