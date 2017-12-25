//
//  ViewController.swift
//  Explore_Reactive_Programming
//
//  Created by Ashis Laha on 23/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    // Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var buttonOutlet: UIButton!
    let vm = ViewModel()
    
    // cold Observable signal
    let coldObservable = Observable<String>.create { (observer) -> Disposable in
        
        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 5.0) // sleep for 5 secs
            observer.onNext("Hi I am a cold signal")
            observer.onCompleted()
        }
        return Disposables.create()
    }
    
    
    // view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleObservableSequence()
        
        handlePublishSubject()
        handleBehaviorSubject()
        handleReplaySubject()
        
        binding()
        bindingUIElements()
        
        handleColdSignal()
        exploreTranformation()
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
    
    // Binding an Observable sequece to a subject
    private func binding() {
        
        let subject = PublishSubject<String>() // Hot Observable
        let observableSequence = Observable<String>.just("Start binding") // Cold Observable
        
        // Subject must subscribe before it sends signal, else signal will not be captured as per Hot Observable property
        subject.subscribe(onNext: { (text) in
            print(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        // Either
        observableSequence.subscribe { (event) in
            subject.on(event)
        }.disposed(by: disposeBag)
        
        // Or
        observableSequence.bind { (event) in
            subject.onNext(event)
        }.disposed(by: disposeBag)
        
    }
    
    // Binding UIElements
    private func bindingUIElements() {
        
        textField.rx.text.orEmpty.bind { (text) in
            print(text)
        }.disposed(by: disposeBag)
        
        buttonOutlet.rx.tap.bind { [weak self] in
            print("Button tapped")
            self?.vm.buttonTappedAction()
        }.disposed(by: disposeBag)
        
    }
    
    // Handle Cold signal
    private func handleColdSignal() {
        // observer
        coldObservable.subscribe { (event) in
            print("\n",event)
        }.disposed(by: disposeBag)
    }

    // Transformation
    private func exploreTranformation() {
        
        // Map
        print("\nMap\n")
        Observable<Int>.of(1,2,3,4).map { element in
            return element * 10
            }.subscribe(onNext: { (val) in
                print(val)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        // flatmap
        print("\nflatMap\n")
        let observableSequence1 = Observable<Int>.of(1,2)
        let observableSequence2 = Observable<Int>.of(3,4)
        
        let sequences = Observable.of(observableSequence1,observableSequence2)
        sequences.flatMap { return $0 }.subscribe(onNext: { (val) in
            print(val)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        // filter
        print("\nFiltering\n")
        let observable3 = Observable<Int>.of(1,2,3,4,5,6)
        observable3.filter { (each) -> Bool in
            return each % 2 == 0
            }.subscribe(onNext: { (val) in
                print(val)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        // distinctUntilChanged
        print("\nDistinctUntilChanged\n")
        let observable4 = Observable<Int>.of(1,1,1,2,3,3,3,3,3,3,4)
        observable4.distinctUntilChanged().subscribe(onNext: { (each) in
            print(each)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        // scan
        print("\nScan\n")
        let observable5 = Observable<Int>.of(1,2,3,4,5)
        observable5.scan(0) { (accumulator, val) -> Int in
            return accumulator + val
            }.subscribe(onNext: { (result) in
                print(result)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
    }
}

class ViewModel {

    public func buttonTappedAction() {
        print("Perform some action")
    }
}

