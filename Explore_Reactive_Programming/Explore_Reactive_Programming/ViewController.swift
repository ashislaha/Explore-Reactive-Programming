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
    let nameSequence = Observable.from(["ashis", "kunal", "ratan", "sam"])
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
        let onNextSubscription = fiboniccaSequence.subscribe(onNext: { (eachElement) in
            print(eachElement)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        onNextSubscription.disposed(by: disposeBag)
        
        //event
        let nameSubsciption = nameSequence.subscribe { (event) in
            switch event {
            case .next(let val): print(val)
            case .completed: print("Completed")
            case .error(let error): print(error)
            }
        }
        nameSubsciption.disposed(by: disposeBag)
        
    }

}

