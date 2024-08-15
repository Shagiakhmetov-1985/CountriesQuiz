//
//  FavouritesViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.08.2024.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonClose: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Избранное"
        label.font = UIFont(name: "mr_fontick", size: 28)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(viewModel.cell, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = viewModel.background
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var viewModel: FavouritesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setSubviews()
        setBarButton()
        setConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    private func setDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonClose, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: labelTitle, tableView, on: view)
    }
    
    @objc private func close() {
        
    }
}

extension FavouritesViewController {
    private func setConstraints() {
        
    }
}
