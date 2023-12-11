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
        tableView.register(checkCell(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = game.background
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var mode: Setting!
    var game: Games!
    var results: [Results]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        mode.flag ? 70 : 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        customCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        detailsVC.mode = mode
        detailsVC.game = game
        detailsVC.result = results[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - General methods
    private func customCell(cell: UITableViewCell, indexPath: IndexPath) {
        if mode.flag {
            flagCell(cell: cell as! CustomCell, indexPath: indexPath)
        } else {
            labelCell(cell: cell as! CustomLabelCell, indexPath: indexPath)
        }
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: labelTitle, tableView, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    @objc private func exitToResults() {
        dismiss(animated: true)
    }
    // MARK: - Properties for any game type
    private func checkCell() -> AnyClass {
        mode.flag ? CustomCell.self : CustomLabelCell.self
    }
    // MARK: - Custom cell for quiestions of flags
    private func flagCell(cell: CustomCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: results[indexPath.row].question.flag)
        cell.progressView.progress = setProgress(value: results[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = game.background
    }
    // MARK: - Custom cell for questions of country name
    private func labelCell(cell: CustomLabelCell, indexPath: IndexPath) {
        cell.labelCountry.text = results[indexPath.row].question.name
        cell.progressView.progress = setProgress(value: results[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = game.background
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
