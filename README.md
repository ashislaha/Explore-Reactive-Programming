# Explore Reactive Programming

Let's Explore Reactive Programming. ( RxSwift and RxCocoa )

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

 ###  Handling behaviorSubject / Variable
 
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
        
        let subject = PublishSubject<String>() // Hot Observable 
        let observableSequence = Observable<String>.just("Start binding") // Cold Observable 
        
        // Subject must subscribe before it sends signal, else signal will not be captured as per Hot Observable property.
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
 
### Output : 

     Start binding
        
## Binding UIElements :

 <b> Outlets and view model  </b>
 
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var buttonOutlet: UIButton!
    let vm = ViewModel()

<b> binding textField and button </b>
    
    private func bindingUIElements() {
        
        textField.rx.text.orEmpty.bind { (text) in
            print(text)
        }.disposed(by: disposeBag)
        
        buttonOutlet.rx.tap.bind { [weak self] in
            print("Button tapped")
            self?.vm.buttonTappedAction()
        }.disposed(by: disposeBag)  
    }
    
    class ViewModel {
       public func buttonTappedAction() {
         print("Perform some action")
       }
    }
    
 <b> Output : </b>
 
 when you write on textField :
         
         H
         He
         Hel
         Hell
         Hello
         Hello 
         Hello w
         Hello wo
  
  When you tap on button : 
     
     Button tapped
     Perform some action

## (3) Cold Observable and Hot Observable :

### Cold Observable : 

It will start executing only when an observer subscribes the observable sequence.

<b> Create a cold observable : </b>
    
    // cold Observable signal
    let coldObservable = Observable<String>.create { (observer) -> Disposable in
        
        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 5.0) // sleep for 5 secs
            observer.onNext("Hi I am a cold signal")
            observer.onCompleted()
        }
        return Disposables.create()
    }
    
<b> Subscribed Observer of cold observable : </b>

     private func handleColdSignal() {
        // observer
        coldObservable.subscribe { (event) in
            print("\n",event)
        }.disposed(by: disposeBag)
    }

### Hot Observable :

A Hot observable executes even if it does not have any Observers.

Subjects are examples of Hot observables like PublishSubject etc.


## (4) Marable Diagram :

It visualises the transformation of an Observable sequence. It consists of there layer :

< Input , Transformation function , OutPut >

![marble diagram](https://user-images.githubusercontent.com/10649284/34340273-28e39124-e9a7-11e7-98e4-91540cf9c80d.png)

## (5) Transformation : 

<b> Sometimes if you want to transform (filter, combine, map etc.) the event/signal emitted by Observable sequence and before receiving to the subscribers, you can do that. </b>

### A. Map : 

        print("\nMap\n")
        Observable<Int>.of(1,2,3,4).map { element in
            return element * 10
            }.subscribe(onNext: { (val) in
                print(val)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)


### Output : 

    Map
    10
    20
    30
    40

### B. FlatMap : 

        print("\nflatMap\n")
        let observableSequence1 = Observable<Int>.of(1,2)
        let observableSequence2 = Observable<Int>.of(3,4)
        
        let sequences = Observable.of(observableSequence1,observableSequence2)
        sequences.flatMap { return $0 }.subscribe(onNext: { (val) in
            print(val)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
### Output : 
   
     flatMap
     1
     2
     3
     4
 
 ### C. Filter : 
   
        print("\nFiltering\n")
        let observable3 = Observable<Int>.of(1,2,3,4,5,6)
        observable3.filter { (each) -> Bool in
            return each % 2 == 0
            }.subscribe(onNext: { (val) in
                print(val)
         }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
   
### Output : 
      
      Filtering
      2
      4
      6

### D. DistinctUntilChanged :

        print("\nDistinctUntilChanged\n")
        let observable4 = Observable<Int>.of(1,1,1,2,3,3,3,3,3,3,4)
        observable4.distinctUntilChanged().subscribe(onNext: { (each) in
            print(each)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
 ### Output : 
 
     DistinctUntilChanged
     1
     2
     3
     4
  
### E. Scan :

        print("\nScan\n")
        let observable5 = Observable<Int>.of(1,2,3,4,5)
        observable5.scan(0) { (accumulator, val) -> Int in
            return accumulator + val
            }.subscribe(onNext: { (result) in
                print(result)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
            
 ### Output : 
 
     Scan
     1
     3
     6
     10
     15
  

### Useful References :

http://swiftpearls.com/RxSwift-for-dummies-1-Observables.html

https://medium.com/ios-os-x-development/learn-and-master-%EF%B8%8F-the-basics-of-rxswift-in-10-minutes-818ea6e0a05b

https://www.raywenderlich.com/138547/getting-started-with-rxswift-and-rxcocoa

http://www.tailec.com/blog/understanding-publish-connect-refcount-share

http://lukajcb.github.io/blog/reactivex/2016/05/04/reactive-uis-with-rx-swift.html

https://www.raywenderlich.com/126522/reactivecocoa-vs-rxswift



