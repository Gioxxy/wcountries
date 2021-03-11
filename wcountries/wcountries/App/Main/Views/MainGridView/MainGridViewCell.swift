//
//  MainGridViewCell.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 27/02/21.
//

import UIKit

final class MainGridViewCell: UICollectionViewCell {
    
    static let cellId = String(describing: self)
    
    private let view = UIView()
    
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
        view.backgroundColor = AppColors.primary
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func addViews(){
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        imageViewShadowContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageViewShadowContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageViewShadowContainer.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageViewShadowContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageViewShadowContainer.trailingAnchor)
        ])
        
        view.addSubview(imageViewShadowContainer)
        imageViewShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewShadowContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewShadowContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageViewShadowContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewShadowContainer.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
