//
//  UITableViewExtension.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import UIKit

extension UITableView {
    func registerClassWithClassName(cellType: UITableViewCell.Type) {
        let className = cellType.className
        register(cellType, forCellReuseIdentifier: className)
    }

    func registerClassWithClassName(reusableViewType: UITableViewHeaderFooterView.Type) {
        let className = reusableViewType.className
        register(reusableViewType, forHeaderFooterViewReuseIdentifier: className)
    }

    func dequeueReusableCellWithClassName<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
