//
//  ViewController.swift
//  flexlayout
//
//  Created by kimchansoo on 2023/01/02.
//

import UIKit
import FlexLayout

class ViewController: UIViewController {
    // MARK: UI
    private var mainView: MainView {
        return self.view as! MainView
    }
    
    // MARK: Properties
    
    // MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let shows = self.loadShows()
        let series = Series(shows: shows)
        self.view = MainView(series: series)
    }
    // MARK: Methods
}

extension ViewController {
    
    // emmit dummy data
    private func loadShows() -> [Show] {
        guard let path = Bundle.main.path(forResource: "Shows", ofType: "plist"),
              let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
            return []
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
        
        return shows
    }
}
