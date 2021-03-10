//
//  ViewController.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private var viewModel: MainViewModel?
    
    private let logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.startAnimating()
        loader.color = AppColors.bubbles
        return loader
    }()
    private let continetFilter = ContinentFilterView()
    private let mainGridView: MainGridView = MainGridView()
    
    func config(viewModel: MainViewModel){
        viewModel.updateGridView = {
            self.mainGridView.update()
        }
        viewModel.showError = { error in
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.showLoader = {
            self.view.addSubview(self.loader)
            self.loader.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.loader.centerXAnchor.constraint(equalTo: self.mainGridView.collectionView.centerXAnchor),
                self.loader.centerYAnchor.constraint(equalTo: self.mainGridView.collectionView.centerYAnchor)
            ])
            self.loader.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.loader.isHidden = false
            })
        }
        viewModel.dismissLoader = {
            self.loader.removeFromSuperview()
        }
        self.viewModel = viewModel
        
        mainGridView.config(self, viewModel: viewModel)
        continetFilter.config(self, viewModel: viewModel.regions)
        filterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFilterButtonTap)))
        
        setupView()
        addViews()
        fetchData()
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.background
    }
    
    private func addViews(){
        let safeArea = view.safeAreaLayoutGuide
        
        // Globe
        let globe = UIImageView(image: UIImage(named: "globe"))
        view.addSubview(globe)
        globe.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globe.topAnchor.constraint(equalTo: view.topAnchor),
            globe.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            globe.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            globe.centerXAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -(UIScreen.main.bounds.width/7))
        ])
        
        // Logo
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeArea.topAnchor),
            logo.heightAnchor.constraint(equalToConstant: 92),
            logo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Filters
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            filterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Continent filter
        view.addSubview(continetFilter)
        continetFilter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continetFilter.topAnchor.constraint(equalTo: logo.bottomAnchor),
            continetFilter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continetFilter.heightAnchor.constraint(equalToConstant: 60),
            continetFilter.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        // GridView
        view.addSubview(mainGridView.collectionView)
        mainGridView.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainGridView.collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainGridView.collectionView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
            mainGridView.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainGridView.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainGridView.collectionView.contentLayoutGuide.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            mainGridView.collectionView.contentLayoutGuide.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainGridView.collectionView.contentLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainGridView.collectionView.contentLayoutGuide.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainGridView.collectionView.contentLayoutGuide.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func fetchData(){
        viewModel?.getCountries()
    }
    
    @objc func onFilterButtonTap(){
        viewModel?.didTapOnFilterButton()
    }
}

// MARK: - MainGridViewDelegate
extension MainViewController: MainGridViewDelegate {
    func onScrollListener(_ gridView: MainGridView, scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 5 {
            UIView.animate(withDuration: 0.5) {
                self.logo.alpha = 1
                self.filterButton.alpha = 1
                self.continetFilter.alpha = 1
            }
        } else if self.logo.alpha == 1 {
            UIView.animate(withDuration: 0.5) {
                self.logo.alpha = 0
                self.filterButton.alpha = 0
                self.continetFilter.alpha = 0
            }
        }
    }
    
    func onItemTap(_ gridView: MainGridView, viewModel: MainViewModel.CountryViewModel) {
        self.viewModel?.didTapOnCountry(viewModel: viewModel)
    }
}

// MARK: - ContinentFilterViewDelegate
extension MainViewController: ContinentFilterViewDelegate {
    func didSelectContinent(continent: MainViewModel.RegionViewModel) {
        viewModel?.didSelectContinent(continent: continent)
    }
    
    func didDeselectContinent(continent: MainViewModel.RegionViewModel){
        viewModel?.didDeselectContinent()
    }
}
