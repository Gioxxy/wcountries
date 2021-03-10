//
//  SearchBarView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 09/03/21.
//

import UIKit

class SearchBarView: UISearchBar, UISearchBarDelegate {
    
    private var timer: Timer?
    
    private var onSearch: ((String)->Void)?
    private var onSearchEnd: (()->Void)?
        
    func config(onSearch: ((String)->Void)? = nil, onSearchEnd: (()->Void)? = nil){
        delegate = self
        self.onSearch = onSearch
        self.onSearchEnd = onSearchEnd
        
        setupView()
        setupShadow()
    }
    
    private func setupView(){
        placeholder = "Search"
        searchBarStyle = .minimal
        tintColor = .black
        backgroundColor = .white
        tintColor = .black
    }
    
    private func setupShadow(){
        if #available(iOS 13, *) {} else {
            layer.borderWidth = 10
            layer.borderColor = #colorLiteral(red: 0.9490041137, green: 0.948971808, blue: 0.9532201886, alpha: 1)
        }
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] timer in
            if searchText == "" {
                self?.timer?.invalidate()
                self?.timer = nil
                self?.onSearchEnd?()
            } else {
                self?.onSearch?(searchText)
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearch?(searchBar.text ?? "")
    }
}
