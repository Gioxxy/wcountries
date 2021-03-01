//
//  MainGridView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import UIKit

protocol MainGridViewDelegate: class {
    func onScrollListener(_ gridView: MainGridView, scrollView: UIScrollView)
    func onItemTap(_ gridView: MainGridView, viewModel: MainViewModel.CountryViewModel)
}

final class MainGridView: UICollectionViewController {
    
    private var viewModel: [MainViewModel.CountryViewModel]?
    weak var delegate: MainGridViewDelegate?
    
    init(){
        let inset = UIScreen.main.bounds.width.truncatingRemainder(dividingBy: 173) / 2
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumInteritemSpacing = 20
        flow.minimumLineSpacing = 20
        flow.itemSize = CGSize(width: 163, height: 163)
        flow.sectionInset = UIEdgeInsets(top: 160, left: inset, bottom: 30, right: inset)
        
        super.init(collectionViewLayout: flow)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainGridViewCell.self, forCellWithReuseIdentifier: MainGridViewCell.cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ delegate: MainGridViewDelegate, viewModel: [MainViewModel.CountryViewModel]) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel = viewModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainGridViewCell.cellId, for: indexPath) as! MainGridViewCell
            cell.config(viewModel: viewModel[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            delegate?.onItemTap(self, viewModel: viewModel[indexPath.row])
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.onScrollListener(self, scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 152)
    }
}
