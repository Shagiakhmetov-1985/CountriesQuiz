//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

class QuestionnaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonBack: UIButton = {
        let button = setButton(
            image: "arrow.backward",
            action: #selector(backToGameType))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = setTableView()
        return tableView
    }()
    
    var mode: Setting!
    var game: Games!
    
    private var timer = Timer()
    private var questions = Countries.getQuestions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
//        setupNavigationBar()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        questions.questions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeader
        view.title.text = "\(section + 1) / \(mode.countQuestions)"
        view.image.image = UIImage(named: questions.questions[section].flag)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionnaireCell
        
        switch indexPath.row {
        case 0:
            cell.title.text = questions.buttonFirst[indexPath.section].name
            cell.image.image = checkImage(questions.buttonFirst[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonFirst[indexPath.section].select)
        case 1:
            cell.title.text = questions.buttonSecond[indexPath.section].name
            cell.image.image = checkImage(questions.buttonSecond[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonSecond[indexPath.section].select)
        case 2:
            cell.title.text = questions.buttonThird[indexPath.section].name
            cell.image.image = checkImage(questions.buttonThird[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonThird[indexPath.section].select)
        default:
            cell.title.text = questions.buttonFourth[indexPath.section].name
            cell.image.image = checkImage(questions.buttonFourth[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonFourth[indexPath.section].select)
        }
        
        cell.layer.borderWidth = 1
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard !questions.buttonFirst[indexPath.section].select else { return }
            
        case 1:
            guard !questions.buttonSecond[indexPath.section].select else { return }
            
        case 2:
            guard !questions.buttonThird[indexPath.section].select else { return }
            
        default:
            guard !questions.buttonFourth[indexPath.section].select else { return }
            
        }
    }
    
    private func setupDesign() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = game.background
        navigationController?.navigationBar.standardAppearance = appearence
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: tableView, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func checkImage(_ checkmark: Bool) -> UIImage? {
        checkmark ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
    
    private func checkColor(_ checkmark: Bool) -> UIColor {
        checkmark ? .systemGreen : .systemRed
    }
    
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup table view
extension QuestionnaireViewController {
    private func setTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(QuestionnaireCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 175
        tableView.rowHeight = 55
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
// MARK: - Setup constraints
extension QuestionnaireViewController {
    private func setupConstraints() {
        setupSquare(subview: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}
