//
//  NeighboringCountriesRow.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 04/03/21.
//

import UIKit

class NeighboringCountriesRow: UIView {
    private var viewModel: DetailViewModel.NeighboringCountriesRow?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.text
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()
    
    private let neighboringCountriesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    func config(viewModel: DetailViewModel.NeighboringCountriesRow, horizontalMargin: CGFloat = 18){
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        
        addViews(horizontalMargin: horizontalMargin)
    }
    
    private func addViews(horizontalMargin: CGFloat){
        if titleLabel.text != nil{
            self.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalMargin),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalMargin),
            ])
        }
        
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        scrollView.addSubview(neighboringCountriesStack)
        neighboringCountriesStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            neighboringCountriesStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            neighboringCountriesStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            neighboringCountriesStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            neighboringCountriesStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            neighboringCountriesStack.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: -6),
        ])
        
        for nc in viewModel?.neighboringCountries ?? [] {
            let ncv = NeighboringCountryView()
            ncv.config(viewModel: nc)
            neighboringCountriesStack.addArrangedSubview(ncv)
        }
        
    }
}
