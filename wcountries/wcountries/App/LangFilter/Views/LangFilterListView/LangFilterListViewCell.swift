//
//  LangFilterListViewCell.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 07/03/21.
//

import UIKit

class LangFilterListViewCell: UITableViewCell {
    static let cellId = String(describing: self)
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = AppColors.background
        cardView.layer.cornerRadius = 10
        return cardView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = AppColors.text
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private let removeIcon = UIImageView(image: UIImage(named: "clear"))
    
    func config(viewModel: LangFilterViewModel.LanguageViewModel) {
        titleLabel.text = viewModel.name
        removeIcon.isHidden = !viewModel.isSelected
        
        addViews()
    }
    
    private func addViews(){
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            cardView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        cardView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18)
        ])
        
        cardView.addSubview(removeIcon)
        removeIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            removeIcon.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18)
        ])
    }
}
