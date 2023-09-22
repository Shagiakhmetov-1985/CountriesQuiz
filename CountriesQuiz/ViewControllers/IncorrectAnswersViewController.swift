//
//  IncorrectAnswersViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2023.
//

import UIKit

class IncorrectAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch game.gameType {
        case .quizOfFlag:
            quizOfFlagsCell(cell: cell, indexPath: indexPath)
        default:
            questionnaireCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func quizOfFlagsCell(cell: UITableViewCell, indexPath: IndexPath) {
        if mode.flag {
            flagCell(cell: cell as! CustomCell, indexPath: indexPath)
        } else {
            labelCell(cell: cell as! CustomLabelCell, indexPath: indexPath)
        }
    }
    
    private func questionnaireCell(cell: UITableViewCell, indexPath: IndexPath) {
        questionnaireCell(cell: cell as! QuestionnaireCell, indexPath: indexPath)
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
    
    private func questionnaireBackground(question: Countries, answer: Countries,
                                         tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer:
            return .white
        case tag == select:
            return .white.withAlphaComponent(0.7)
        default:
            return .clear
        }
    }
    
    private func questionnaireColorText(question: Countries, answer: Countries,
                                        tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .greenHarlequin
        default:
            return .white
        }
    }
    
    private func setImage(question: Countries, answer: Countries,
                          tag: Int, select: Int) -> String {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return "checkmark.circle.fill"
        case !(question == answer) && tag == select:
            return "xmark.circle.fill"
        default:
            return "circle"
        }
    }
    
    private func setColorImage(question: Countries, answer: Countries,
                               tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenHarlequin
        case !(question == answer) && tag == select:
            return .greenHarlequin
        default:
            return .white
        }
    }
    
    private func timeUpCheck(bool: Bool) -> String {
        bool ? "Истекло время!" : ""
    }
    
    private func checkCell() -> AnyClass {
        switch game.gameType {
        case .quizOfFlag:
            return quizOfFlagsCell()
        default:
            return questionnaireCell()
        }
    }
    
    private func quizOfFlagsCell() -> AnyClass {
        mode.flag ? CustomCell.self : CustomLabelCell.self
    }
    
    private func questionnaireCell() -> AnyClass {
        QuestionnaireCell.self
    }
    
    private func checkHeight() -> CGFloat {
        switch game.gameType {
        case .quizOfFlag:
            return mode.flag ? 350 : 315
        default:
            return 350
        }
    }
    
    private func flagCell(cell: CustomCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: results[indexPath.section].question.flag)
        
        setProgressViewAndLabel(progressView: cell.progressView, label: cell.labelNumber,
                                currentQuestion: results[indexPath.section].currentQuestion)
//        cell.progressView.progress = setProgress(value: results[indexPath.section].currentQuestion)
//        cell.labelNumber.text = setText(value: results[indexPath.section].currentQuestion)
        
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
        
        setProgressViewAndLabel(progressView: cell.progressView, label: cell.labelNumber,
                                currentQuestion: results[indexPath.section].currentQuestion)
//        cell.progressView.progress = setProgress(value: results[indexPath.section].currentQuestion)
//        cell.labelNumber.text = setText(value: results[indexPath.section].currentQuestion)
        
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
    
    private func questionnaireCell(cell: QuestionnaireCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: results[indexPath.section].question.flag)
        
        setProgressViewAndLabel(progressView: cell.progressView, label: cell.labelNumber,
                                currentQuestion: results[indexPath.section].currentQuestion,
                                color: .white)
        
        configure(indexPath: indexPath, button: cell.buttonFirst,
                  label: cell.titleFirst, image: cell.checkmarkFirst,
                  answer: results[indexPath.section].buttonFirst, tag: 1)
        
        configure(indexPath: indexPath, button: cell.buttonSecond,
                  label: cell.titleSecond, image: cell.checkmarkSecond,
                  answer: results[indexPath.section].buttonSecond, tag: 2)
        
        configure(indexPath: indexPath, button: cell.buttonThird,
                  label: cell.titleThird, image: cell.checkmarkThird,
                  answer: results[indexPath.section].buttonThird, tag: 3)
        
        configure(indexPath: indexPath, button: cell.buttonFourth,
                  label: cell.titleFourth, image: cell.checkmarkFourth,
                  answer: results[indexPath.section].buttonFourth, tag: 4)
    }
    
    private func configure(indexPath: IndexPath, button: UIView, label: UILabel,
                           image: UIImageView, answer: Countries, tag: Int) {
        buttonBackground(button: button, answer: answer, indexPath: indexPath, tag: tag)
        labelText(label: label, answer: answer)
        labelColor(label: label, answer: answer, indexPath: indexPath, tag: tag)
        setImage(image: image, answer: answer, indexPath: indexPath, tag: tag)
        setImageColor(image: image, answer: answer, indexPath: indexPath, tag: tag)
    }
    
    private func setProgressViewAndLabel(progressView: UIProgressView, label: UILabel,
                                         currentQuestion: Int, color: UIColor? = nil) {
        progressView.progress = setProgress(value: currentQuestion)
        label.text = setText(value: currentQuestion)
        if let color = color {
            label.textColor = color
        }
    }
    
    private func buttonBackground(button: UIView, answer: Countries,
                                  indexPath: IndexPath, tag: Int) {
        button.backgroundColor = questionnaireBackground(
            question: results[indexPath.section].question,
            answer: answer, tag: tag, select: results[indexPath.section].tag)
    }
    
    private func labelText(label: UILabel, answer: Countries) {
        label.text = answer.name
    }
    
    private func labelColor(label: UILabel, answer: Countries,
                            indexPath: IndexPath, tag: Int) {
        label.textColor = questionnaireColorText(
            question: results[indexPath.section].question,
            answer: answer, tag: tag, select: results[indexPath.section].tag)
    }
    
    private func setImage(image: UIImageView, answer: Countries,
                          indexPath: IndexPath, tag: Int) {
        let size = UIImage.SymbolConfiguration(pointSize: 22)
        image.image = UIImage(
            systemName: setImage(question: results[indexPath.section].question,
            answer: answer, tag: tag, select: results[indexPath.section].tag),
            withConfiguration: size)
    }
    
    private func setImageColor(image: UIImageView, answer: Countries,
                               indexPath: IndexPath, tag: Int) {
        image.tintColor = setColorImage(
            question: results[indexPath.section].question,
            answer: answer, tag: tag, select: results[indexPath.section].tag)
    }
}
// MARK: - Setup buttons
extension IncorrectAnswersViewController {
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
extension IncorrectAnswersViewController {
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
extension IncorrectAnswersViewController {
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
extension IncorrectAnswersViewController {
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
