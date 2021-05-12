//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 송우진 on 2021/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoComposeViewModel!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // double tap을 방지하기 위해 0.5초마다 tap을 처리
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        
        let willShowObservalbe = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObservable = Observable.merge(willShowObservalbe, willHideObservable).share()
        
        keyboardObservable
            .subscribe(onNext: { [weak self] height in
                guard let strongSelf = self else { return }
                
                var inset = strongSelf.contentTextView.contentInset
                inset.bottom = height
                
                var scrollInset = strongSelf.contentTextView.scrollIndicatorInsets
                scrollInset.bottom = height
                
                UIView.animate(withDuration: 0.3) {
                    strongSelf.contentTextView.contentInset = inset
                    strongSelf.contentTextView.scrollIndicatorInsets = scrollInset
                }
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    

}
