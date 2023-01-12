//
//  MovieListView.swift
//  flexlayout-test
//
//  Created by kimchansoo on 2023/01/02.
//

import UIKit
import FlexLayout
import PinLayout

final class MovieListView: UIView {
    // MARK: UI
    private let contentView = UIScrollView()
    private let rootFlexContainer = UIView()
    
    let episodeImageView = UIImageView()
    let summaryPopularityLabel = UILabel()
    let episodeTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let showsTableView = ExpandedTableView()
    
    
    // MARK: Properties
    let showSelectedIndex = 0
    let series: Series
    
    // MARK: Initializers
    init(series: Series) {
        print(#function)
        self.series = series
        super.init(frame: .zero)
        
        self.backgroundColor = .black
        
        let padding: CGFloat = 8
        let paddingHorizontal: CGFloat = 8.0
            
        summaryPopularityLabel.text = String(repeating: "★", count: series.showPopularity)
        summaryPopularityLabel.textColor = .red
        
        // Year
        let yearLabel = UILabel()
        yearLabel.text = series.showYear
        yearLabel.textColor = .lightGray
        
        // Rating
        let ratingLabel = UILabel()
        ratingLabel.text = series.showRating
        ratingLabel.textColor = .lightGray

        // Length
        let lengthLabel = UILabel()
        lengthLabel.text = series.showLength
        lengthLabel.textColor = .lightGray
        
        // Episode Title
        let episodeIdLabel = showLabelFor(text: series.selectedShow, font: .boldSystemFont(ofSize: 16.0))
        
        // Description
        initLabelFor(descriptionLabel, font: .systemFont(ofSize: 14.0))
        descriptionLabel.numberOfLines = 3
        
        // Cast & creators
        let castLabel = showLabelFor(text: "Cast: \(series.showCast)", font: .boldSystemFont(ofSize: 14.0))
        let creatorsLabel = showLabelFor(text: "Creators: \(series.showCreators)", font: .boldSystemFont(ofSize: 14.0))
        
        let addActionView = showActionViewFor(imageName: "add", text: "My List")
        let shareActionView = showActionViewFor(imageName: "share", text: "Share")

        // Tabs
        let episodeTabView = showTabBarFor(text: "EPISODES", selected: true)
        let moreTabView = showTabBarFor(text: "MORE LIKE THIS", selected: false)
        

        
        rootFlexContainer.flex.define { flex in
            // Image
            flex.addItem(episodeImageView).grow(1).aspectRatio(1).backgroundColor(.gray)
            
            // Summary row
            flex.addItem().direction(.row).padding(padding).define { flex in
                flex.addItem(summaryPopularityLabel).grow(1)
                
                flex.addItem().direction(.row).justifyContent(.spaceBetween).grow(2).define { flex in
                    flex.addItem(yearLabel)
                    flex.addItem(ratingLabel)
                    flex.addItem(lengthLabel)
                }
                
                flex.addItem().width(100).height(1).grow(1)
            }
            
            // Title row
            flex.addItem().direction(.row).padding(padding).define { flex in
                flex.addItem(episodeIdLabel)
                flex.addItem(episodeTitleLabel).marginLeft(20)
            }
            
            // Description section
            flex.addItem().paddingHorizontal(paddingHorizontal).define { flex in
                flex.addItem(descriptionLabel)
                flex.addItem(castLabel)
                flex.addItem(creatorsLabel)
            }
            
            // Action row
            flex.addItem().direction(.row).padding(padding).define { flex in
                flex.addItem(addActionView)
                flex.addItem(shareActionView)
            }
            
            // Tabs row
            flex.addItem().direction(.row).padding(padding).define { flex in
                flex.addItem(episodeTabView)
                flex.addItem(moreTabView)
            }
            
            // Shows TableView
            flex.addItem(showsTableView).grow(1)
        }
        
        contentView.addSubview(rootFlexContainer)
        
        addSubview(contentView)
        
//        didSelectShow(show: series.shows[0])
//        showsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        // 1) Layout the contentView & rootFlexContainer using PinLayout
        contentView.pin.all(pin.safeArea)
        rootFlexContainer.pin.top().left().right()

        // 2) Let the flexbox container layout itself and adjust the height
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        // 3) Adjust the scrollview contentSize
        contentView.contentSize = rootFlexContainer.frame.size
    }
}

extension MovieListView {
    
    private func showLabelFor(text: String? = nil, font: UIFont = .systemFont(ofSize: 14.0)) -> UILabel {
        let label = UILabel(frame: .zero)
        initLabelFor(label, text: text, font: font)
        return label
    }
    
    private func initLabelFor(_ label: UILabel, text: String? = nil, font: UIFont = .systemFont(ofSize: 14.0)) {
        label.font = font
        label.textColor = .lightGray
        label.text = text
        label.flex.marginBottom(5)
    }

    private func showActionViewFor(imageName: String, text: String) -> UIView {
        let actionView = UIView()
        
        actionView.flex.alignItems(.center).width(50).marginRight(20.0).define { (flex) in
            let actionButton = UIButton(type: .custom)
            actionButton.setImage(UIImage(named: imageName), for: .normal)
            flex.addItem(actionButton).padding(10)
            
            let actionLabel = showLabelFor(text: text)
            flex.addItem(actionLabel)
        }
        
        return actionView
    }
    
    private func showTabBarFor(text: String, selected: Bool) -> UIView {
        let tabLabelFont = selected ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
        
        let labelSize = text.size(withAttributes: [NSAttributedString.Key.font: tabLabelFont])
        
        let tabView = UIView()
        
        tabView.flex.alignItems(.center).marginRight(20).define { (flex) in
            let tabSelectionView = UIView()
            flex.addItem(tabSelectionView).width(labelSize.width).height(3).marginBottom(5).backgroundColor(selected ? .red : .clear)
       
            let tabLabel = showLabelFor(text: text, font: tabLabelFont)
            flex.addItem(tabLabel)
        }
        
        return tabView
    }

    func didSelectShow(show: Show) {
        // Episode image
        let image = UIImage(named: show.image)
        let imageAspectRatio = (image?.size.width ?? 1.0) / (image?.size.height ?? 1.0)
        episodeImageView.image = image
        episodeImageView.flex.aspectRatio(imageAspectRatio).markDirty()
        
        episodeTitleLabel.text = show.title
        episodeTitleLabel.flex.markDirty()
        
        descriptionLabel.text = show.detail
        descriptionLabel.flex.markDirty()
        
        // Force a relayout
        setNeedsLayout()
    }
}
