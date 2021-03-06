//
//  ContinentFilterView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 05/03/21.
//

import UIKit

protocol ContinentFilterViewDelegate: class {
    func didSelectContinent(continent: MainViewModel.RegionViewModel)
    func didDeselectContinent(continent: MainViewModel.RegionViewModel)
}

class ContinentFilterView: UIStackView {
    private var viewModel: [MainViewModel.RegionViewModel]?
    private weak var delegate: ContinentFilterViewDelegate?
    
    func config(_ delegate: ContinentFilterViewDelegate?, viewModel: [MainViewModel.RegionViewModel]){
        self.viewModel = viewModel
        self.delegate = delegate
        
        setupView()
        addViews()
    }
    
    func setupView(){
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
    }
    
    func addViews(){
        viewModel?.forEach({ continentViewModel in
            let continent = ContinentFilterViewCell()
            continent.config(self, viewModel: continentViewModel)
            self.addArrangedSubview(continent)
        })
    }
}

extension ContinentFilterView: ContinentFilterViewCellDelegate {
    func didTapOnCell(cell: ContinentFilterViewCell, viewModel: MainViewModel.RegionViewModel) {
        self.subviews.forEach({ ($0 as? ContinentFilterViewCell)?.setDeselected() })
        
        if !viewModel.isSelected {
            self.viewModel?.forEach({ $0.isSelected = false })
            viewModel.isSelected = true
            cell.setSelected()
            delegate?.didSelectContinent(continent: viewModel)
        } else {
            self.viewModel?.forEach({ $0.isSelected = false })
            delegate?.didDeselectContinent(continent: viewModel)
        }
    }
}
