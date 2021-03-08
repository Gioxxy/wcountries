//
//  ContinentFilterViewCell.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 05/03/21.
//

import UIKit

protocol ContinentFilterViewCellDelegate: class {
    func didTapOnCell(cell: ContinentFilterViewCell, viewModel: MainViewModel.RegionViewModel)
}

class ContinentFilterViewCell: UIView {
    
    private weak var delegate: ContinentFilterViewCellDelegate?
    private var viewModel: MainViewModel.RegionViewModel?
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    func config(_ delegate: ContinentFilterViewCellDelegate? = nil, viewModel: MainViewModel.RegionViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        if let imageName = viewModel.imageName {
            imageView.image = UIImage(named: imageName)
        }
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 45)
        widthConstraint = self.widthAnchor.constraint(equalToConstant: 45)
        
        setupView()
        addViews()
    }
    
    private func setupView(){
        self.backgroundColor = AppColors.primary
        self.layer.cornerRadius = 22.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    private func addViews(){
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint?.isActive = true
        widthConstraint?.isActive = true
    }
    
    func setSelected(){
        heightConstraint?.constant = 60
        widthConstraint?.constant = 60
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.layer.cornerRadius = 30
            self.imageView.layer.cornerRadius = 30
            self.layoutIfNeeded()
        }
    }
    
    func setDeselected(){
        heightConstraint?.constant = 45
        widthConstraint?.constant = 45
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.layer.cornerRadius = 22.5
            self.imageView.layer.cornerRadius = 22.5
            self.layoutIfNeeded()
        }
    }
    
    @objc func onTap(){
        if let viewModel = self.viewModel {
            delegate?.didTapOnCell(cell: self, viewModel: viewModel)
        }
    }
}
