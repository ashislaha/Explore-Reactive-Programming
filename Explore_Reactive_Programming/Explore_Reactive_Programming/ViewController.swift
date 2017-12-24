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
    
    // let's explore Subjects
    var publishSubject = PublishSubject<String>()
    var behaviorSubject = BehaviorSubject<String>(value: "Behavior1")
    var variable = Variable<String>("Variable1") // wrapper of BehaviorSubject
    var replaySubject = ReplaySubject<String>.create(bufferSize: 3) // create a buffer to store the most recently nth number of events are stored
    
    
    // disposeBag
    let disposeBag = DisposeBag()
    
    // view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleObservableSequence()
        
        handlePublishSubject()
        handleBehaviorSubject()
        handleReplaySubject()
    }
    
    // Handling Observable sequence
    private func handleObservableSequence() {
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
    
    // Handling publishSubject
    private func handlePublishSubject() {
        // send signals
        publishSubject.onNext("Event1 - Not printed - PublishSubject")
        publishSubject.onNext("Event2 - Not printed - PublishSubject")
        
        // subscribe
        publishSubject.subscribe(onNext: { (event) in
            print("\n",event)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        publishSubject.onNext("Event3 - Printed - PublishSubject")
        publishSubject.onNext("Event4 - Printed - PublishSubject")
    }

    
    // Handling behaviorSubject and Variable
    private func handleBehaviorSubject() {
        // send signals
        behaviorSubject.onNext("Event1 - Not printed - BehaviorSubject")
        behaviorSubject.onNext("Event2 - printed - BehaviorSubject") // receive the most recent event
        
        // subscribe
        behaviorSubject.subscribe(onNext: { (event) in
            print("\n",event)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        behaviorSubject.onNext("Event3 - Printed - BehaviorSubject")
        behaviorSubject.onNext("Event4 - Printed - BehaviorSubject")
    }
    
    // Handling ReplaySubject
    private func handleReplaySubject() {
        // send signals
        replaySubject.onNext("Event1 - Not printed - ReplaySubject") // Buffer capacity is 3
        replaySubject.onNext("Event2 - printed - ReplaySubject")
        replaySubject.onNext("Event3 - Printed - ReplaySubject")
        replaySubject.onNext("Event4 - Printed - ReplaySubject")
        
        // subscribe
        replaySubject.subscribe(onNext: { (event) in
            print("\n",event)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        replaySubject.onNext("Event5 - Printed - ReplaySubject")
        replaySubject.onNext("Event6 - Printed - ReplaySubject")
        
    }

}

