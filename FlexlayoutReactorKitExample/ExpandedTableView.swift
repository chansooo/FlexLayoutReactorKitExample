//
//  ExpandedTableView.swift
//  flexlayout-test
//
//  Created by kimchansoo on 2023/01/02.
//

import UIKit

class ExpandedTableView: UITableView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let nbOfCells = numberOfRows(inSection: 0)
        let cellsHeight = delegate?.tableView?(self, heightForRowAt: IndexPath(row: 0, section: 0)) ?? 0
        return CGSize(width: size.width, height: CGFloat(nbOfCells) * cellsHeight)
    }
}
