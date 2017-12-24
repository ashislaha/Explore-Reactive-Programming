# Explore Reactive Programming

Let's Explore Reactive Programming. (RxSwift)

In Computing , reactive programming is a programming paradigm oriented around data flow and the propagation of changes.

Swift version of Reactive programming : RxSwift : 

## (1). Observable sequence : 

Everything in RxSwift is observable sequence and something that subscribes the events emitted by observable sequence.

Array, Dictionary, string will be converted into observable sequence in RxSwift. You can create Observable sequence of any object that conforms <b>“Sequence”</b> protocol.

let’s create some observable sequence :

    let helloSwift = Observable.just("Hello World")
    let fiboniccaSequence = Observable.from([0,1,1,2,3,5,8])
    let dictSequence = Observable.from(["1" : 1, "2" : 2])
    let nameSequence = Observable.from(["ashis", "kunal", "ratan", "sam"])
    let disposeBag = DisposeBag()
 
You can subscribe those observable sequence to observe it. 

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

## Output :

     next(Hello World)
     completed

     0
     1
     1
     2
     3
     5
     8

     ashis
     kunal
     ratan
     sam
     Completed

Observable Sequence can emit 0 or more signal/event in their lifetime.

### In RxSwift, an Event is an Enum type of 3 different possible types  : 

(A) <b>.next(value : T):</b>  When a value is added to an Observable Sequence, it triggers the next event to its subscribers. 

(B) <b>.error(error : Error): </b> If an error happens, the Observable Sequence emits an error event to its subscribers.

(C) <b>.completed :</b>  If an Observable Sequence ends normally then it emits  a “completed” signal to its subscribers.

### Unregister subscription :
If you want to cancel a subscription, you can call dispose method.

      eventSubscription.dispose() 

Or you can add this to disposeBag which will cancel the subscription automatically in deinit method.
       
     eventSubscription.disposed(by: disposeBag)

## (2) Subjects : 

A Subject is a special form of Observable sequence, you can subscribe and dynamically add item to it. 

There are 4 kinds of subjects are there : 

<b>(1) PublishSubject:</b> 
     If you subscribe to it, you will get all the events after subscription. 

<b>(2) BehaviourSubject :</b>  If you subscribe to it, you will get the most recent element.

<b>(3) ReplaySubject :</b>  If you want to replay more than the most recent element to new subscribers then use ReplaySubject.

<b>(4) Variable :</b> Wrapper of BehaviourSubject to look and feel for non-reactive programming style.

The basic difference in terms of number of past N events in 4 subjects :

PublishSubject : 0 catch event 

BehaviourSubject and Variable : 1 event (the recent event)

ReplaySubject : N events (based on Buffer capacity )


### Examples : 

    // let's explore Subjects
    var publishSubject = PublishSubject<String>()
    var behaviorSubject = BehaviorSubject<String>(value: "Behavior1")
    var variable = Variable<String>("Variable1") // wrapper of BehaviorSubject
    var replaySubject = ReplaySubject<String>.create(bufferSize: 3) // create a buffer to store the most recently nth number of events are stored
    
    
 ### Handling publishSubject : 
 
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

### Output : 

       Event3 - Printed - PublishSubject

       Event4 - Printed - PublishSubject

 ###  Handling behaviorSubject and Variable
 
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
    
### Output : 

    Event2 - printed - BehaviorSubject

    Event3 - Printed - BehaviorSubject

    Event4 - Printed - BehaviorSubject
    
    
 ### Handling ReplaySubject : 
 
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
    
 ### Output : 
    
    Event2 - printed - ReplaySubject

    Event3 - Printed - ReplaySubject

    Event4 - Printed - ReplaySubject

    Event5 - Printed - ReplaySubject

    Event6 - Printed - ReplaySubject

## Binding : 

<b> Binding an Observable Sequence to a subject : </b>
    
    private func binding() {
        
        let subject = PublishSubject<String>()
        let observableSequence = Observable<String>.just("Start binding")
        
        subject.subscribe(onNext: { (text) in
            print(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        // Either
        observableSequence.subscribe { (event) in
            subject.on(event)
        }.disposed(by: disposeBag)
        
        // Or use observableSequence.bindTo(subject)
    }
    
 ### Output : 
        Start binding
        

# Useful References :

http://swiftpearls.com/RxSwift-for-dummies-1-Observables.html

https://medium.com/ios-os-x-development/learn-and-master-%EF%B8%8F-the-basics-of-rxswift-in-10-minutes-818ea6e0a05b

https://www.raywenderlich.com/138547/getting-started-with-rxswift-and-rxcocoa



