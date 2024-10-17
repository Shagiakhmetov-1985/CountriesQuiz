//
//  SettingViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.12.2022.
//

import UIKit

protocol SettingViewControllerInput {
    func dataToSetting(mode: Setting)
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonBack: UIButton = {
        setButton(
            image: "multiply",
            color: .white,
            action: #selector(backToMenu))
    }()
    
    private lazy var buttonDefault: UIButton = {
        setButton(
            image: "arrow.counterclockwise",
            color: .white,
            action: #selector(defaultSetting))
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(text: viewModel.title, size: 28, color: .white)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: "gear", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelTitle, imageTitle])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(viewModel.cell, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blueMiddlePersian
        tableView.separatorColor = .blueMiddlePersian
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = viewModel.heightOfRow
        return tableView
    }()
    
    var viewModel: SettingViewModelProtocol!
    var delegate: MenuViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButtons()
        setSubviews()
        setConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell as! SettingCell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transition(row: indexPath.row, section: indexPath.section)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: SettingViewControllerInput {
    func dataToSetting(mode: Setting) {
        viewModel.setMode(mode)
        tableView.reloadData()
    }
}

extension SettingViewController {
    private func setDesign() {
        view.backgroundColor = .blueBlackSea
    }
    
    private func setBarButtons() {
        viewModel.setBarButtons(buttonBack, buttonDefault, and: navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: stackView, tableView, on: view)
    }
    
    @objc private func backToMenu() {
        delegate.modeToMenu(setting: viewModel.mode)
        StorageManager.shared.saveSetting(setting: viewModel.mode)
        dismiss(animated: true)
    }
    
    @objc private func defaultSetting() {
        let alert = viewModel.showAlert(viewModel.mode, buttonDefault, and: tableView)
        present(alert, animated: true)
    }
    
    private func transition(row: Int, section: Int) {
        switch (row, section) {
        case (0, 0): countQuestionsViewController()
        case (1, 0): continentsViewController()
        case (2, 0): timeViewController()
        default: break
        }
    }
    
    private func countQuestionsViewController() {
        let countQuestionsViewModel = viewModel.countQuestionsViewController()
        let countQuestionsVC = CountQuestionsViewController()
        countQuestionsVC.viewModel = countQuestionsViewModel
        countQuestionsVC.delegate = self
        navigationController?.pushViewController(countQuestionsVC, animated: true)
    }
    
    private func continentsViewController() {
        let continentsViewModel = viewModel.continentsViewController()
        let continentsVC = ContinentsViewController()
        continentsVC.viewModel = continentsViewModel
        continentsVC.delegate = self
        navigationController?.pushViewController(continentsVC, animated: true)
    }
    
    private func timeViewController() {
        let timeViewModel = viewModel.timeViewController()
        let timeVC = TimeViewController()
        timeVC.viewModel = timeViewModel
        timeVC.delegate = self
        navigationController?.pushViewController(timeVC, animated: true)
    }
}

extension SettingViewController {
    private func setButton(image: String, color: UIColor, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.layer.cornerRadius = 12
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

extension SettingViewController {
    private func setConstraints() {
        viewModel.setSquare(subviews: buttonBack, buttonDefault, sizes: 40)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
