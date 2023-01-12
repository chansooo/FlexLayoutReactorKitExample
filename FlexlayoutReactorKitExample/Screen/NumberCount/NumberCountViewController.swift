//
//  NumberCountViewController.swift
//  FlexlayoutReactorKitExample
//
//  Created by kimchansoo on 2023/01/06.
//

import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import ReactorKit

final class NumberCountViewController: UIViewController, View {
    
    // MARK: UI
    private let rootFlexContainer = UIView()
    
    private lazy var countLabel = UILabel()
    
    private lazy var prevPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("prev page", for: .normal)
        return button
    }()
    
    private lazy var nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("next page", for: .normal)
        return button
    }()
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Initializers
    init(with reactor: NumberCountReactor) {
        super.init(nibName: nil, bundle: nil)
        countLabel.text = "1"
        configureLayout()
        self.reactor = reactor
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        view.backgroundColor = .red
        print(#function)
    }
    
//    override func loadView() {
//        print(#function)
////        configureLayout()
//    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
//        configureLayout()
    }
    
    func bind(reactor: NumberCountReactor) {
        print(#function)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func configureLayout() {

        
        rootFlexContainer
            .flex
            .direction(.column)
            .alignItems(.center)
            .justifyContent(.center)
            .backgroundColor(.brown)
            .define { flex in
                flex.addItem(countLabel).backgroundColor(.yellow).marginBottom(50)
                
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(prevPageButton).backgroundColor(.systemCyan).marginRight(20)
                    flex.addItem(nextPageButton).backgroundColor(.systemMint)
                }
            }
        
        self.view.addSubview(rootFlexContainer)
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout(mode: .fitContainer)
        self.view.frame.size = rootFlexContainer.frame.size

    }
    
    private func bindAction(reactor: NumberCountReactor) {
        prevPageButton.rx.tap.asObservable()
            .map { NumberCountReactor.Action.decrementButtonDidTab }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 한 번 누르면 이벤트 한 번 발생. 두번 누르면 계속 발생
        nextPageButton.rx.tap.asObservable()
            .debug()
            .map { NumberCountReactor.Action.incrementButtonDidTab }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: NumberCountReactor) {
        reactor.state.map { $0.count }
            .debug()
            .map { "\($0)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
