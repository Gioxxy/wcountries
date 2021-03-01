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
    
    private var mainGridView: MainGridView = MainGridView()

    func config(viewModel: MainViewModel){
        self.viewModel = viewModel
        
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
        viewModel?.getCountries(
            onSuccess: { viewModel in
                self.mainGridView.config(self, viewModel: viewModel.countries)
                self.mainGridView.collectionView.reloadData()
            },
            onError: { error in
                // TODO: show error
                print(error)
            }
        )
    }
}

extension MainViewController: MainGridViewDelegate {
    func onScrollListener(_ gridView: MainGridView, scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 5 {
            UIView.animate(withDuration: 0.5) {
                self.logo.alpha = 1
            }
        } else if self.logo.alpha == 1 {
            UIView.animate(withDuration: 0.5) {
                self.logo.alpha = 0
            }
        }
    }
    
    func onItemTap(_ gridView: MainGridView, viewModel: MainViewModel.CountryViewModel) {
        self.viewModel?.didTapOnCountry(viewModel: viewModel)
    }
    
    
}
