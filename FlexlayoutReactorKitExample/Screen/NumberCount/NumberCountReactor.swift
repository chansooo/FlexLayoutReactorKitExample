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
//        case increaseNumber
//        case decreaseNumber
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
            steps.accept(NumberCountStep.numberCountCompleted)
            return .empty()
        case .incrementButtonDidTab:
            print("increment action")
            steps.accept(NumberCountStep.nextNumberCountRequired(withCount: self.currentState.count + 1))
            return .empty()
        }
    }
    
//    func reduce(state: State, mutation: Mutation) -> State {
//        print("reduce")
//        var newState = state
//        switch mutation {
//        case .increaseNumber:
//            newState.count += 1
//        case .decreaseNumber:
//            newState.count -= 1
//        }
//        return newState
//    }
    
    private func showNextView(state: State) -> Observable<Mutation> {
        steps.accept(NumberCountStep.nextNumberCountRequired(withCount: state.count + 1))
        return Observable.empty()
    }
    
}
