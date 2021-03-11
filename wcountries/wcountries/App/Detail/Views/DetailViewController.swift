//
//  DetailViewController.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 28/02/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel?
    
    private let backButton: UIButton = {
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
        let container = UIView()
        container.contentMode = .scaleAspectFill
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        container.layer.shadowRadius = 3
        container.layer.shadowOpacity = 0.2
        container.layer.masksToBounds = false
        container.layer.shouldRasterize = true
        container.layer.rasterizationScale = UIScreen.main.scale
        return container
    }()
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let regionImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let currencySimbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AvenirNext-Bold", size: 23)
        label.textAlignment = .center
        return label
    }()
    
    private let callingCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    func config(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.background
        titleLabel.text = viewModel?.country.name
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: AppColors.accent,
            NSAttributedString.Key.foregroundColor: UIColor.clear,
            NSAttributedString.Key.strokeWidth: 8
        ]
        subTitleLabel.attributedText = NSMutableAttributedString(string: viewModel?.country.alpha3Code ?? "", attributes: strokeTextAttributes)
        
        imageView.imageFromNetwork(
            url: viewModel?.country.imageURL,
            then: { [weak self] image in
                // Set aspect ratio
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
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 18)
        ])
        
        // Add title
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
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
        
        // Add scrollView
        let scrollView = PassThroughScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 300, left: 18, bottom: 18, right: 18)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add container
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -36),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
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
        containerView.addSubview(imageViewShadowContainer)
        imageViewShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewShadowContainer.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            imageViewShadowContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageViewShadowContainer.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 100),
            imageViewShadowContainer.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -100),
            imageViewShadowContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 400)
        ])
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.color = AppColors.bubbles
        guard let viewModel = viewModel else { return }
        viewModel.getCountry(
            alpha3Code: viewModel.country.alpha3Code,
            onStart: {
                self.containerView.addSubview(spinner)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    spinner.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
                    spinner.topAnchor.constraint(equalTo: self.imageViewShadowContainer.bottomAnchor, constant: 50)
                ])
            },
            onCompletion: {
                spinner.removeFromSuperview()
            },
            onSuccess: { [weak self] viewModel in
                guard let self = self else { return }
                
                // Add horizontal stack container
                let bubblesStack: UIStackView = UIStackView()
                bubblesStack.spacing = 15
                bubblesStack.axis = .horizontal
                
                self.containerView.addSubview(bubblesStack)
                bubblesStack.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    bubblesStack.topAnchor.constraint(equalTo: self.imageViewShadowContainer.bottomAnchor, constant: 38),
                    bubblesStack.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
                ])
                
                self.currencySimbolLabel.text = viewModel.country.currencySimbol
                self.callingCodeLabel.text = viewModel.country.callingCode
                
                // Add region image
                if let regionImage = viewModel.country.region?.imageName {
                    self.regionImageView.image = UIImage(named: regionImage)
                    let regionImageViewShadowContainer = BubbleView()
                    regionImageViewShadowContainer.config(contentView: self.regionImageView)
                    bubblesStack.addArrangedSubview(regionImageViewShadowContainer)
                    regionImageViewShadowContainer.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        regionImageViewShadowContainer.heightAnchor.constraint(equalToConstant: 44),
                        regionImageViewShadowContainer.widthAnchor.constraint(equalToConstant: 44)
                    ])
                }
                
                // Add currency simbol
                if viewModel.country.currencySimbol != nil {
                    let currencySimbolShadowContainer = BubbleView()
                    currencySimbolShadowContainer.config(contentView: self.currencySimbolLabel)
                    bubblesStack.addArrangedSubview(currencySimbolShadowContainer)
                    currencySimbolShadowContainer.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        currencySimbolShadowContainer.heightAnchor.constraint(equalToConstant: 44),
                        currencySimbolShadowContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
                    ])
                }
                
                // Add calling code
                if viewModel.country.callingCode != nil {
                    let callingCodeShadowContainer = BubbleView()
                    callingCodeShadowContainer.config(contentView: self.callingCodeLabel)
                    bubblesStack.addArrangedSubview(callingCodeShadowContainer)
                    callingCodeShadowContainer.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        callingCodeShadowContainer.heightAnchor.constraint(equalToConstant: 44),
                        callingCodeShadowContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
                    ])
                }
                
                // Add details
                let detailsStack = UIStackView()
                detailsStack.axis = .vertical
                detailsStack.spacing = 18
                
                self.containerView.addSubview(detailsStack)
                detailsStack.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    detailsStack.topAnchor.constraint(equalTo: bubblesStack.bottomAnchor, constant: 38),
                    detailsStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 18),
                    detailsStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -18)
                ])
                
                for detail in viewModel.country.details {
                    let nativeNameDetailRow = DetailRow()
                    nativeNameDetailRow.config(viewModel: detail)
                    detailsStack.addArrangedSubview(nativeNameDetailRow)
                }
                
                // Add neighboring countries
                if let viewModel = viewModel.neighboringCountries {
                    let neighboringCountriesRow = NeighboringCountriesRow()
                    neighboringCountriesRow.config(viewModel: viewModel)
                    self.containerView.addSubview(neighboringCountriesRow)
                    neighboringCountriesRow.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        neighboringCountriesRow.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 20),
                        neighboringCountriesRow.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                        neighboringCountriesRow.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
                    ])
                }
                
                if let lastView = self.containerView.subviews.last {
                    NSLayoutConstraint.activate([
                        self.containerView.bottomAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 18)
                    ])
                }
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        )
    }
    
    @objc private func onBackTap(sender: UIButton!){
        viewModel?.onBackDidTap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel?.onClose()
    }
}
