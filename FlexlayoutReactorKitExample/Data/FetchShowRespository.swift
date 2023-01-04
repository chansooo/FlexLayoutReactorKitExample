//
//  FetchShowRespository.swift
//  FlexlayoutReactorKitExample
//
//  Created by kimchansoo on 2023/01/04.
//

import Foundation

import RxSwift

protocol FetchShowRepository {
    func execute() -> Single<[Show]>
}

final class FetchShowRepositoryImpl: FetchShowRepository {
    // emmit dummy data
    func execute() -> Single<[Show]> {
        return Single.create { single in
            guard let path = Bundle.main.path(forResource: "Shows", ofType: "plist"),
                  let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
                single(.failure(LocalError.unknown))
                return Disposables.create()
            }
            
            var shows: [Show] = []
            
            dictArray.forEach { (dict) in
                guard
                    let title = dict["title"] as? String,
                    let length = dict["length"] as? String,
                    let detail = dict["detail"] as? String,
                    let image = dict["image"] as? String
                    else {
                        fatalError("Error parsing dict \(dict)")
                }
                
                let show = Show(title: title, length: length, detail: detail, image: image)
                shows.append(show)
            }
            single(.success(shows))
            return Disposables.create()
        }
    }

}
