//
//  PassThroughCollectionView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import UIKit

class PassThroughCollectionView: UICollectionView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView is PassThroughCollectionView {
                return nil
            } else {
                return hitView
            }
        } else {
            return nil
        }
    }
}
