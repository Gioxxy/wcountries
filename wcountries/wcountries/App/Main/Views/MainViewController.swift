//
//  ViewController.swift
//  wcountries
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private let logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFit
        return logo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func config(){
        view.backgroundColor = AppColors.background
        addViews()
    }
    
    private func addViews(){
        let safeArea = view.safeAreaLayoutGuide
        // Logo
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeArea.topAnchor),
            logo.heightAnchor.constraint(equalToConstant: 92),
            logo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

