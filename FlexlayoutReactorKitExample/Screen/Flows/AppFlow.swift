//
//  AppFlow.swift
//  RxFlowReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

final class AppStepper: Stepper {
    var steps = PublishRelay<Step>()

    var disposebag = DisposeBag()
    
    var initialStep: Step {
        return AppStep.tabbarIsRequired
    }
    
    func readyToEmitSteps() {
        Observable.just(AppStep.tabbarIsRequired)
            .bind(to: steps)
            .disposed(by: disposebag)
    }
}

final class AppFlow: Flow {
    
    enum TabIndex: Int {
        case movieList = 0
        case numberCount
    }

    // MARK: Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = MainTabbarController()
    
    private let rootWindow: UIWindow
    
    // tabbar에 들어갈 flow들
    let movieListFlow = MovieListFlow()
    let numberCountFlow = NumberCountFlow()

    
    // MARK: Initializers
    init(
        with window: UIWindow
    ){
        self.rootWindow = window
        window.rootViewController = rootViewController
    }
    
    // MARK: Methods
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .tabbarIsRequired:
            return navigateToTabBar()
        }
    }
    
    private func navigateToTabBar() -> FlowContributors {
        
        Flows.use(movieListFlow, numberCountFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "MovieList", image: UIImage(systemName: "popcorn.circle"), selectedImage: nil)
            
            let tabBarItem2 = UITabBarItem(title: "Count", image: UIImage(systemName: "12.circle"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root2.tabBarItem = tabBarItem2
            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }
        
        return .multiple(flowContributors: [
            // 나중에는 flow의 생성자에 stepper를 만들어서 넣어주면서 하면 의존성 주입까지 신경 쓸 수 있을 듯
            .contribute(
                withNextPresentable: movieListFlow,
                withNextStepper: movieListFlow.stepper
            ),
            .contribute(
                withNextPresentable: numberCountFlow,
                withNextStepper: numberCountFlow.stepper
            )
        ])
    }
}
