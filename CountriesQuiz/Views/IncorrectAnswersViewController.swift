//
//  IncorrectAnswersViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2023.
//

import UIKit

class IncorrectAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonBack: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitToResults), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Неправильные ответы"
        label.font = UIFont(name: "mr_fontick", size: 28)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(viewModel.checkCell(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = viewModel.game.background
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var viewModel: IncorrectAnswersViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let incorrectViewModel = viewModel.detailsViewModel(indexPath.row)
        let incorrectVC = IncorrectViewController()
        incorrectVC.viewModel = incorrectViewModel
        navigationController?.pushViewController(incorrectVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.game.background
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: labelTitle, tableView, on: view)
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc private func exitToResults() {
        dismiss(animated: true)
    }
}
// MARK: - Setup constraints
extension IncorrectAnswersViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonBack.widthAnchor.constraint(equalToConstant: 40),
            buttonBack.heightAnchor.constraint(equalToConstant: 40)
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
