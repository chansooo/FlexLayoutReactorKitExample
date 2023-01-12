//
//  NumberCountReactor.swift
//  FlexlayoutReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import Foundation

import ReactorKit
import RxCocoa
import RxFlow

final class NumberCountReactor: Reactor, Stepper {
    
    // 뷰에서 어떤 action이 일어났는지
    enum Action {
        case incrementButtonDidTab
        case decrementButtonDidTab
    }
    
    // reactor 내부 로직
    enum Mutation {
        case showPrevView
        case showNextView
    }
    
    // 뷰에 보여줄 값
    struct State {
        var count: Int
    }
    
    // MARK: Properties
    var steps = PublishRelay<Step>()
    
    var initialState: State
    
    // MARK: Initializers
    init(count: Int) {
        self.initialState = State(count: count)
    }
    
    // MARK: Methods
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .decrementButtonDidTab:
//            if newCount < 0 {
//                steps.accept(NumberCountStep.minusCountAlertRequired(message: "rootViewController입니다."))
//                return .empty()
//            }
//            steps.accept(NumberCountStep.numberCountCompleted)
            return Observable.just(Mutation.showPrevView)
//            return .empty()
        case .incrementButtonDidTab:
            print("increment action")
            return Observable.just(Mutation.showNextView)
            
//            steps.accept(NumberCountStep.nextNumberCountRequired(withCount: newCount))
//            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        print("reduce")
        var newState = state
        switch mutation {
        case .showPrevView:
            newState.count -= 1
        case .showNextView:
            newState.count += 1
        }
        return newState
    }
}
