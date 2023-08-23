//
//  WrongAnswersViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2023.
//

import UIKit

class WrongAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonBack: UIButton = {
        let button = setupButton(
            image: "multiply",
            action: #selector(exitToResults))
        return button
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = setupLabel(title: "Неправильные ответы")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = setupTableView()
        return tableView
    }()
    
    var mode: Setting!
    var results: [Results]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if mode.flag {
            flagCell(cell: cell as! CustomCell, indexPath: indexPath)
        } else {
            labelCell(cell: cell as! CustomLabelCell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func setupDesign() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: buttonBack, labelTitle, tableView, on: view)
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
    
    @objc private func exitToResults() {
        dismiss(animated: true)
    }
    
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    private func setColorTitle(question: Countries, answer: Countries, tag: Int,
                               select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .grayLight
        }
    }
    
    private func setColorBackground(question: Countries, answer: Countries, tag: Int,
                                    select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenYellowBrilliant
        case !(question == answer) && tag == select:
            return .redTangerineTango
        default:
            return mode.flag ? .white.withAlphaComponent(0.9) : .skyGrayLight
        }
    }
    
    private func timeUpCheck(bool: Bool) -> String {
        bool ? "Истекло время!" : ""
    }
    
    private func checkCell() -> AnyClass {
        mode.flag ? CustomCell.self : CustomLabelCell.self
    }
    
    private func checkHeight() -> CGFloat {
        mode.flag ? 350 : 315
    }
    
    private func flagCell(cell: CustomCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: results[indexPath.section].question.flag)
        
        cell.progressView.progress = setProgress(value: results[indexPath.section].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.section].currentQuestion)
        
        cell.buttonFirst.text = results[indexPath.section].buttonFirst.name
        cell.buttonFirst.textColor = setColorTitle(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFirst, tag: 1,
            select: results[indexPath.section].tag)
        cell.buttonFirst.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFirst, tag: 1,
            select: results[indexPath.section].tag)
        
        cell.buttonSecond.text = results[indexPath.section].buttonSecond.name
        cell.buttonSecond.textColor = setColorTitle(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonSecond, tag: 2,
            select: results[indexPath.section].tag)
        cell.buttonSecond.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonSecond, tag: 2,
            select: results[indexPath.section].tag)
        
        cell.buttonThird.text = results[indexPath.section].buttonThird.name
        cell.buttonThird.textColor = setColorTitle(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonThird, tag: 3,
            select: results[indexPath.section].tag)
        cell.buttonThird.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonThird, tag: 3,
            select: results[indexPath.section].tag)
        
        cell.buttonFourth.text = results[indexPath.section].buttonFourth.name
        cell.buttonFourth.textColor = setColorTitle(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFourth, tag: 4,
            select: results[indexPath.section].tag)
        cell.buttonFourth.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFourth, tag: 4,
            select: results[indexPath.section].tag)
        
        cell.timeUp.text = timeUpCheck(bool: results[indexPath.section].timeUp)
    }
    
    private func labelCell(cell: CustomLabelCell, indexPath: IndexPath) {
        cell.labelName.text = results[indexPath.section].question.name
        
        cell.progressView.progress = setProgress(value: results[indexPath.section].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.section].currentQuestion)
        
        cell.imageFirst.image = UIImage(named: results[indexPath.section].buttonFirst.flag)
        cell.viewFirst.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFirst, tag: 1,
            select: results[indexPath.section].tag)
        
        cell.imageSecond.image = UIImage(named: results[indexPath.section].buttonSecond.flag)
        cell.viewSecond.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonSecond, tag: 2,
            select: results[indexPath.section].tag)
        
        cell.imageThird.image = UIImage(named: results[indexPath.section].buttonThird.flag)
        cell.viewThird.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonThird, tag: 3,
            select: results[indexPath.section].tag)
        
        cell.imageFourth.image = UIImage(named: results[indexPath.section].buttonFourth.flag)
        cell.viewFourth.backgroundColor = setColorBackground(
            question: results[indexPath.section].question,
            answer: results[indexPath.section].buttonFourth, tag: 4,
            select: results[indexPath.section].tag)
        
        cell.timeUp.text = timeUpCheck(bool: results[indexPath.section].timeUp)
    }
}
// MARK: - Setup buttons
extension WrongAnswersViewController {
    private func setupButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .blueBlackSea
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.blueBlackSea.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup labels
extension WrongAnswersViewController {
    private func setupLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: 28)
        label.textColor = .blueBlackSea
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup table view
extension WrongAnswersViewController {
    private func setupTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(checkCell(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = checkHeight()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
// MARK: - Setup constraints
extension WrongAnswersViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonBack.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorCheck()),
            buttonBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        setupSquare(subview: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: buttonBack.bottomAnchor, constant: 20),
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
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func topAnchorCheck() -> CGFloat {
        view.frame.height > 736 ? 60 : 30
    }
}
