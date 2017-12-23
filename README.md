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

(A.) <b>.next(value : T):</b>  When a value is added to an Observable Sequence, it triggers the next event to its subscribers. 

(B.) <b>.error(error : Error): </b> If an error happens, the Observable Sequence emits an error event to its subscribers.

(C.) <b>.completed :</b>  If an Observable Sequence ends normally then it emits  a “completed” signal to its subscribers.



