//
//  AppStep.swift
//  RxFlowReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import UIKit
import RxFlow

enum AppStep: Step {
    case tabbarIsRequired
}

enum MovieListStep: Step {
    case moviesAreRequired
    case seriesPicked(show: Show)
}

enum NumberCountStep: Step {
    case nextNumberCountRequired(withCount: Int)
    case numberCountCompleted
    case minusCountAlertRequired(message: String)
}
