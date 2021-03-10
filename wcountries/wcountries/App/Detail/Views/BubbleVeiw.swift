//
//  BubbleVeiw.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 02/03/21.
//

import UIKit

class BubbleView: UIView {
    private var contentView: UIView?
    
    func config(contentView: UIView){
        self.contentView = contentView
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        backgroundColor = AppColors.bubbles
        layer.cornerRadius = 22
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func addViews(){
        if let contentView = contentView {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
