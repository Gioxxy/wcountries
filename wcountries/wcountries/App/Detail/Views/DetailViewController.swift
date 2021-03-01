//
//  DetailViewController.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel?
    
    private let backButtoon: UIButton = {
        let arrowBack = UIButton(type: .custom)
        arrowBack.setImage(UIImage(named: "arrowBack"), for: .normal)
        arrowBack.tintColor = AppColors.accent
        arrowBack.addTarget(self, action: #selector(onBackTap), for: .touchUpInside)
        return arrowBack
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = AppColors.accent
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 40)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private let subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = AppColors.accent
        subTitleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 23)
        subTitleLabel.textAlignment = .left
        return subTitleLabel
    }()
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.masksToBounds = false
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        return containerView
    }()
    
    private let imageViewShadowContainer: UIView = {
        let imageViewShadowContainer = UIView()
        imageViewShadowContainer.contentMode = .scaleToFill
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
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func config(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.background
        titleLabel.text = viewModel?.name
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: AppColors.accent,
            NSAttributedString.Key.foregroundColor: UIColor.clear,
            NSAttributedString.Key.strokeWidth: 8
        ]
        subTitleLabel.attributedText = NSMutableAttributedString(string: viewModel?.alpha3Code ?? "", attributes: strokeTextAttributes)
        
        imageView.imageFromNetwork(
            url: viewModel?.imageURL,
            then: { [weak self] image in
                // Set flag aspect ratio
                if let imageViewShadowContainer = self?.imageViewShadowContainer {
                    let aspectRatio = image.size.width / image.size.height
                    imageViewShadowContainer.widthAnchor.constraint(equalTo: imageViewShadowContainer.heightAnchor, multiplier: aspectRatio).isActive = true
                }
            }
        )
    }
    
    private func addViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        // Add globe
        let globe = UIImageView(image: UIImage(named: "globe"))
        view.addSubview(globe)
        globe.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globe.topAnchor.constraint(equalTo: view.topAnchor),
            globe.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            globe.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            globe.centerXAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -(UIScreen.main.bounds.width/7))
        ])
        
        // Add back button
        view.addSubview(backButtoon)
        backButtoon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButtoon.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            backButtoon.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 18)
        ])
        
        // Add title
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButtoon.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
        
        // Add subTitle
        view.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 5),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
        
        // Add container
        view.addSubview(containerView)
//        let bottomInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0 ? 0 : -18
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            containerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        ])
        
        // Add image
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
            imageViewShadowContainer.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            imageViewShadowContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageViewShadowContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 100),
            imageViewShadowContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -100)
        ])
    }
    
    @objc private func onBackTap(sender: UIButton!){
        viewModel?.onBackDidTap()
    }
}
