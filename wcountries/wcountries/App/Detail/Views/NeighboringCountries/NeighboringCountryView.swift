//
//  NeighboringCountryView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 05/03/21.
//

import UIKit

class NeighboringCountryView: UIView {
    private var viewModel: DetailViewModel.NeighboringCountry?
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func config(viewModel: DetailViewModel.NeighboringCountry){
        self.viewModel = viewModel
        imageView.imageFromNetwork(
            url: viewModel.imageURL
//            then: { [weak self] image in
                // Set aspect ratio
//                if let contentView = self?.contentView {
//                    let aspectRatio = image.size.width / image.size.height
//                    contentView.translatesAutoresizingMaskIntoConstraints = false
//                    contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: aspectRatio).isActive = true
//                }
//            }
        )
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        self.contentMode = .redraw
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func addViews() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
