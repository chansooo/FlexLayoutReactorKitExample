//
//  MainReactor.swift
//  FlexlayoutReactorKitExample
//
//  Created by kimchansoo on 2023/01/04.
//

import Foundation

import ReactorKit
import RxSwift

final class MainReactor: Reactor {
    
    // 뷰에서 어떤 action이 일어났는지
    enum Action {
        case viewDidLoad
        case tableDidTab(Show)
    }
    
    // reactor 내부 로직
    enum Mutation {
        case requestShows(shows: [Show])
        case setSelectedItem(title: String)
    }
    
    // 뷰에 보여줄 값
    struct State {
        var shows: [Show]
        var selectedTitle: String
    }

    // MARK: Properties
    var initialState: State
    private let fetchShowRepository: FetchShowRepository
    
    // MARK: Initializers
    init(fetchShowRepository: FetchShowRepository) {
        initialState = State(shows: [], selectedTitle: "")
        self.fetchShowRepository = fetchShowRepository
    }
    
    // MARK: Methods
    
    // action -> mutation (각각의 action이 수행할 mutation을 정의)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tableDidTab(let show):
            return Observable.concat([
                Observable.just(Mutation.setSelectedItem(title: show.title))
            ])
        case .viewDidLoad:
            return self.fetchShows()
        }
    }
    
    // mutation -> state (mutate에서 변환된 값을 state에 적용)
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSelectedItem(title: let title):
            state.selectedTitle = title
            return state
        case .requestShows(shows: let shows):
            state.shows = shows
            return state
        }
    }
}

extension MainReactor {
    
    func fetchShows() -> Observable<Mutation> {
        return fetchShowRepository
            .execute()
            .asObservable()
            .map { Mutation.requestShows(shows: $0) }
    }
}
