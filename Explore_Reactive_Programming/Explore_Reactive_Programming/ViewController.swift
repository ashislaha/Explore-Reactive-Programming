//
//  ViewController.swift
//  Explore_Reactive_Programming
//
//  Created by Ashis Laha on 23/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    // let's create some observable sequence :
    
    let helloSwift = Observable.just("Hello World")
    let fiboniccaSequence = Observable.from([0,1,1,2,3,5,8])
    let dictSequence = Observable.from(["1" : 1, "2" : 2])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // subscribe
        
        // event
        let eventSubscription = helloSwift.subscribe { (event) in
            print(event)
        }
        eventSubscription.disposed(by: disposeBag)
        
        // onNext
        let onNextSubscription = fiboniccaSequence.subscribe(onNext: { (arr) in
            print(arr)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        onNextSubscription.disposed(by: disposeBag)
        
    }

}

