//
//  MainGridViewCell.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import UIKit

final class MainGridViewCell: UICollectionViewCell {
    
    static let cellId = String(describing: self)
    
    private let imageViewShadowContainer: UIView = {
        let imageViewShadowContainer = UIView()
        imageViewShadowContainer.layer.shadowColor = UIColor.black.cgColor
        imageViewShadowContainer.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        imageViewShadowContainer.layer.shadowRadius = 3
        imageViewShadowContainer.layer.shadowOpacity = 0.2
        imageViewShadowContainer.layer.masksToBounds = false
        imageViewShadowContainer.layer.shouldRasterize = true
        imageViewShadowContainer.layer.rasterizationScale = UIScreen.main.scale
        return imageViewShadowContainer
    }()
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = AppColors.text
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    func config(viewModel: MainViewModel.CountryViewModel) {
        imageView.imageFromNetwork(url: viewModel.imageURL)
        titleLabel.text = viewModel.name
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        contentView.backgroundColor = AppColors.primary
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    private func addViews(){
        
        imageViewShadowContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageViewShadowContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageViewShadowContainer.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageViewShadowContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageViewShadowContainer.trailingAnchor)
        ])
        
        contentView.addSubview(imageViewShadowContainer)
        imageViewShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewShadowContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageViewShadowContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            imageViewShadowContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewShadowContainer.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
