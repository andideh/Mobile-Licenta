//
//  CollectionView+Extensions.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


extension UICollectionView {
    
    func dequeReusableCell<T: UICollectionViewCell & Reusable>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as! T
        return cell
    }
}


extension UITableView {
    
    func dequeReusableCell<T: UITableViewCell & Reusable>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! T
        return cell
    }
}
