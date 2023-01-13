//
//  MainTabBarController.swift
//  FlexlayoutReactorKitExample
//
//  Created by kimchansoo on 2023/01/13.
//

import UIKit

final class MainTabbarController: UITabBarController {
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI
private extension MainTabbarController {
    func configureVC() {
        tabBar.backgroundColor = .gray
    }
}

