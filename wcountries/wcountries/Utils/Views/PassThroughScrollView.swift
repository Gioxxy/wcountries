//
//  PassThroughScrollView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import UIKit

class PassThroughScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView is PassThroughScrollView {
                return nil
            } else {
                return hitView
            }
        } else {
            return nil
        }
    }
}
