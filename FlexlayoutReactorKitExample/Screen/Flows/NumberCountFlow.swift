//
//  NumberCountFlow.swift
//  RxFlowReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

final class NumberCountStepper: Stepper {
    
    var steps = PublishRelay<Step>()
        
    var initialStep: Step {
        return NumberCountStep.nextNumberCountRequired(withCount: 0)
    }
}


final class NumberCountFlow: Flow {

    // MARK: Properties
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    let stepper = NumberCountStepper()

    // MARK: Initializers

    // MARK: Methods
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NumberCountStep else { return .none }
        
        switch step {
        case .nextNumberCountRequired(let withCount):
            return navigateNextPage(count: withCount)
        case .numberCountCompleted:
            print("didididididididii")
//            self.rootViewController.dismiss(animated: true)
            self.rootViewController.popViewController(animated: true)
            return .none
        case .minusCountAlertRequired(let message):
            return .none
        }
    }
    
    private func navigateNextPage(count: Int) -> FlowContributors {
        let reactor = NumberCountReactor(count: count)
        let vc = NumberCountViewController(with: reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor:
                .contribute(
                    withNextPresentable: vc,
                    withNextStepper: reactor
                ))
    }
    
}

