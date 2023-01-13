//
//  ViewController.swift
//  flexlayout
//
//  Created by kimchansoo on 2023/01/02.
//

import UIKit

import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class MovieListViewController: UIViewController, View {
    
    // MARK: UI
    private var mainView: MovieListView {
        return self.view as! MovieListView
    }
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Initializers
    init(with reactor: MovieListReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func bind(reactor: MovieListReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.showsTableView.backgroundColor = self.mainView.backgroundColor
        self.mainView.showsTableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.reuseIdentifier)
    }
    
    override func loadView() {
        let shows: [Show] = []
        let series = Series(shows: shows)
        self.view = MovieListView(series: series)
    }

    private func bindAction(_ reactor: MovieListReactor) {
        self.mainView.showsTableView.rx.modelSelected(Show.self)
            .asObservable()
            .map { Reactor.Action.tableDidTab($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.just(Void())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: MovieListReactor) {

        reactor.state
            .map { $0.shows }
//            .debug()
            .bind(to: self.mainView.showsTableView.rx.items(cellIdentifier: ShowTableViewCell.reuseIdentifier, cellType: ShowTableViewCell.self)) { index, model, cell in
                cell.configure(show: model)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedShow }
            .skip(1)
            .subscribe(onNext: { show in
                self.mainView.didSelectShow(show: show)
            })
            .disposed(by: disposeBag)
    }
}
