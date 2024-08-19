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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell as! FavouritesCell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightOfRow
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
        NSLayoutConstraint.activate([
            buttonClose.widthAnchor.constraint(equalToConstant: 40),
            buttonClose.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
