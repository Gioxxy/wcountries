//
//  LangFilterViewController.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 06/03/21.
//

import UIKit

class LangFilterViewController: UIViewController {
    
    private var viewModel: LangFilterViewModel?
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = AppColors.accent
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "clear"), for: .normal)
        return closeButton
    }()
    
    private let searchBar = SearchBarView()
    
    private let listView = LangFilterListView()
    
    func config(viewModel: LangFilterViewModel){
        viewModel.updateListView = {
            self.listView.update()
        }
        self.viewModel = viewModel
        titleLabel.text = "Filtra per lingua"
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapClose)))
        searchBar.config(
            onSearch: { [weak self] text in
                self?.viewModel?.onSearch(text: text)
            },
            onSearchEnd: { [weak self] in
                self?.viewModel?.onSearchEnd()
            }
        )
        listView.config(self, viewModel: viewModel)
        
        setupView()
        addViews()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.onClose()
        super.viewWillDisappear(animated)
    }
    
    private func setupView(){
        view.backgroundColor = UIColor.white
    }
    
    private func addViews(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
        
        view.addSubview(listView.tableView)
        listView.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            listView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchData(){
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.color = AppColors.bubbles
        viewModel?.getLanguages(
            onStart: { [weak self] in
                guard let self = self else { return }
                self.view.addSubview(spinner)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    spinner.centerXAnchor.constraint(equalTo: self.listView.tableView.centerXAnchor),
                    spinner.centerYAnchor.constraint(equalTo: self.listView.tableView.centerYAnchor)
                ])
            },
            onCompletion: {
                spinner.removeFromSuperview()
            },
            onSuccess: { [weak self] viewModel in
                self?.listView.update()
            },
            onError: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true, completion: nil)
            }
        )
    }
    
    @objc private func onTapClose(){
        dismiss(animated: true)
    }
}

// MARK: - LangFilterListViewDelegate
extension LangFilterViewController: LangFilterListViewDelegate {
    func onItemSelected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel) {
        self.viewModel?.onLanguageSelected(viewModel: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func onItemDeselected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel) {
        self.viewModel?.onLanguageDeselected(viewModel: viewModel)
    }
}
