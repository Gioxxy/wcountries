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
    
    private let listView = LangFilterListView()
    
    func config(viewModel: LangFilterViewModel){
        self.viewModel = viewModel
        listView.config(self, viewModel: viewModel)
        titleLabel.text = "Filtra per lingua"
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapClose)))
        
        setupView()
        addViews()
        fetchData()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        viewModel?.onClose()
        super.dismiss(animated: flag, completion: completion)
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
        
        view.addSubview(listView.tableView)
        listView.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            listView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchData(){
        viewModel?.getLanguages(
            onStart: {},
            onCompletion: {},
            onSuccess: { [weak self] viewModel in
                self?.listView.update(viewModel: viewModel.languages)
            },
            onError: { error in
                // TODO: Show error
                print(error)
            }
        )
    }
    
    @objc private func onTapClose(){
        dismiss(animated: true)
    }
}

extension LangFilterViewController: LangFilterListViewDelegate {
    func onItemSelected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel) {
        self.viewModel?.onLanguageSelected(viewModel: viewModel)
    }
    
    func onItemDeselected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel) {
        self.viewModel?.onLanguageDeselected(viewModel: viewModel)
    }
}
