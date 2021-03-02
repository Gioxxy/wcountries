//
//  DetailRow.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 02/03/21.
//

import UIKit

class DetailRow: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.text
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.text
        label.font = UIFont(name: "AvenirNext-Medium", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    func config(title: String, description: String? = nil){
        titleLabel.text = title
        descriptionLabel.text = description
        
        setupView()
        addViews()
    }
    
    func config(viewModel: DetailViewModel.DetailRowViewModel){
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.detail
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        axis = .vertical
    }
    
    private func addViews(){
        if titleLabel.text != nil{
            self.addArrangedSubview(titleLabel)
        }
        if descriptionLabel.text != nil {
            self.addArrangedSubview(descriptionLabel)
        }
    }
}
