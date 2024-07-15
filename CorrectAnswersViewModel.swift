//
//  CorrectAnswersViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 14.07.2024.
//

import UIKit

protocol CorrectAnswersViewModelProtocol {
    var game: Games { get }
    var title: String { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Corrects])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    
    func correctViewModel(_ indexPath: Int) -> CorrectViewModelProtocol
}

class CorrectAnswersViewModel: CorrectAnswersViewModelProtocol {
    var game: Games
    var title = "Правильные ответы"
    var cell: AnyClass = CustomCell.self
    var numberOfRows: Int {
        correctAnswers.count
    }
    var heightOfRow: CGFloat = 70
    
    private let mode: Setting
    private let correctAnswers: [Corrects]
    
    required init(mode: Setting, game: Games, correctAnswers: [Corrects]) {
        self.game = game
        self.mode = mode
        self.correctAnswers = correctAnswers
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func setSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    func customCell(cell: UITableViewCell, indexPath: IndexPath) {
        flagCell(cell: cell as! CustomCell, indexPath: indexPath)
    }
    
    func correctViewModel(_ indexPath: Int) -> CorrectViewModelProtocol {
        CorrectViewModel(mode: mode, game: game, correctAnswer: correctAnswers[indexPath])
    }
    // MARK: - Constants
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    private func flagCell(cell: CustomCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: correctAnswers[indexPath.row].question.flag)
        cell.progressView.progress = setProgress(value: correctAnswers[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: correctAnswers[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = game.background
    }
}
