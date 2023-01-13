//
//  MovieListFlow.swift
//  RxFlowReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import UIKit
import RxFlow
import RxCocoa

struct MovieListStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step{
        return MovieListStep.moviesAreRequired
    }
}

final class MovieListFlow: Flow {

    // MARK: Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    let stepper = MovieListStepper()
    
    // MARK: Initializers
    
    // MARK: Methods
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MovieListStep else { return .none }
        
        switch step {
        case .moviesAreRequired:
            return navigateToMovieListScreen()
        case .seriesPicked(let show):
            return showPickAlert(show: show)
        }
    }
    
    private func navigateToMovieListScreen() -> FlowContributors {
        let fetchShowRepository = FetchShowRepositoryImpl()
        let reactor = MovieListReactor(fetchShowRepository: fetchShowRepository)
        let viewcontroller = MovieListViewController(with: reactor)
        self.rootViewController.pushViewController(viewcontroller, animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewcontroller,
            withNextStepper: reactor
        ))
    }
    
    private func showPickAlert(show: Show) -> FlowContributors {
        let title = show.title
        print(title)
        let alert = UIAlertController(title: title, message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.rootViewController.present(alert, animated: true)
        return .none
    }
}
