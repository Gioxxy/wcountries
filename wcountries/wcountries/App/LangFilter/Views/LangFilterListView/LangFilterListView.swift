//
//  LangFilterListView.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 07/03/21.
//

import UIKit

protocol LangFilterListViewDelegate: class {
    func onItemSelected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel)
    func onItemDeselected(_ listView: LangFilterListView, viewModel: LangFilterViewModel.LanguageViewModel)
}

class LangFilterListView: UITableViewController {
    
    private weak var delegate: LangFilterListViewDelegate?
    private var viewModel: LangFilterViewModel?
    
    func config(_ delegate: LangFilterListViewDelegate? = nil, viewModel: LangFilterViewModel){
        self.delegate = delegate
        self.viewModel = viewModel
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(LangFilterListViewCell.self, forCellReuseIdentifier: LangFilterListViewCell.cellId)
    }
    
    func update(viewModel: [LangFilterViewModel.LanguageViewModel]) {
        self.viewModel?.languages = viewModel
        tableView.performBatchUpdates({
            tableView.reloadSections(IndexSet(0...1), with: .fade)
        }, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel?.selectedLanguages.count ?? 0
        case 1:
            return viewModel?.unselectedLanguages.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LangFilterListViewCell.cellId, for: indexPath) as! LangFilterListViewCell
        if indexPath.section == 0, let selectedLanguages = viewModel?.selectedLanguages {
            cell.config(viewModel: selectedLanguages[indexPath.row])
        } else if indexPath.section == 1, let unselectedLanguages = viewModel?.unselectedLanguages {
            cell.config(viewModel: unselectedLanguages[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if indexPath.section == 0 {
            let item = viewModel.selectedLanguages[indexPath.row]
            delegate?.onItemDeselected(self, viewModel: item)
        } else if indexPath.section == 1 {
            let item = viewModel.unselectedLanguages[indexPath.row]
            delegate?.onItemSelected(self, viewModel: item)
        }
        tableView.performBatchUpdates({
            tableView.reloadSections(IndexSet(1...1), with: .fade)
            tableView.reloadSections(IndexSet(0...0), with: .right)
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
}
