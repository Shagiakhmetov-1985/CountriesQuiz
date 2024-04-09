//
//  IncorrectAnswersViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.04.2024.
//

import UIKit

protocol IncorrectAnswersViewModelProtocol {
    var numberOfRows: Int { get }
    var heightForRow: CGFloat { get }
    
    var mode: Setting { get }
    var game: Games { get }
    var results: [Results] { get }
    
    init(mode: Setting, game: Games, results: [Results])
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    
    func isFlag() -> Bool
    func checkCell() -> AnyClass
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    
    func detailsViewModel(_ indexPath: Int) -> DetailsViewModelProtocol
}

class IncorrectAnswersViewModel: IncorrectAnswersViewModelProtocol {
    var numberOfRows: Int {
        results.count
    }
    var heightForRow: CGFloat {
        isFlag() ? 70 : 95
    }
    
    let mode: Setting
    let game: Games
    let results: [Results]
    
    required init(mode: Setting, game: Games, results: [Results]) {
        self.mode = mode
        self.game = game
        self.results = results
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    // MARK: - Constants
    func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    func customCell(cell: UITableViewCell, indexPath: IndexPath) {
        if isFlag() {
            flagCell(cell: cell as! CustomCell, indexPath: indexPath)
        } else {
            labelCell(cell: cell as! CustomLabelCell, indexPath: indexPath)
        }
    }
    // MARK: - Properties for any game type
    func checkCell() -> AnyClass {
        isFlag() ? CustomCell.self : CustomLabelCell.self
    }
    // MARK: - Constants, countinue
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
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
    // MARK: - Transition to DetailsViewController
    func detailsViewModel(_ indexPath: Int) -> DetailsViewModelProtocol {
        DetailsViewModel(mode: mode, game: game, result: results[indexPath])
    }
}
