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

final class MainViewController: UIViewController, View {
    
    // MARK: UI
    private var mainView: MainView {
        return self.view as! MainView
    }
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Initializers
    
    // MARK: Methods
    func bind(reactor: MainReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.mainView.showsTableView.delegate = self
//        self.mainView.showsTableView.dataSource = self
        self.mainView.showsTableView.backgroundColor = self.mainView.backgroundColor
        self.mainView.showsTableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.reuseIdentifier)
    }
    
    override func loadView() {
        let shows: [Show] = []
        let series = Series(shows: shows)
        self.view = MainView(series: series)
    }
    
    private func bindAction(_ reactor: MainReactor) {
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
    
    private func bindState(_ reactor: MainReactor) {
        
        reactor.state
            .map { $0.shows }
            .bind(to: self.mainView.showsTableView.rx.items(cellIdentifier: ShowTableViewCell.reuseIdentifier)) { index, model, cell in
                guard let cell = cell as? ShowTableViewCell else { return }
                cell.configure(show: model)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedTitle }
            .subscribe { [weak self] title in
                let alert = UIAlertController(title: title, message: title, preferredStyle: .alert)
                self?.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
//
//// MARK: - UITableViewDataSource methods
//extension MainViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return series.shows.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.reuseIdentifier, for: indexPath) as! ShowTableViewCell
//        cell.configure(show: series.shows[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        didSelectShow(show: series.shows[indexPath.row])
//    }
//}
