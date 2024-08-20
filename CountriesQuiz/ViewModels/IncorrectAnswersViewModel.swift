//
//  IncorrectAnswersViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.04.2024.
//

import UIKit

protocol IncorrectAnswersViewModelProtocol {
    var background: UIColor { get }
    var title: String { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightForRow: CGFloat { get }
    
    init(mode: Setting, game: Games, results: [Incorrects], favourites: [Favourites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    
    func detailsViewModel(_ indexPath: Int) -> IncorrectViewModelProtocol
}

class IncorrectAnswersViewModel: IncorrectAnswersViewModelProtocol {
    var background: UIColor {
        game.background
    }
    var title: String = "Неправильные ответы"
    var cell: AnyClass {
        isFlag ? FlagCell.self : NameCell.self
    }
    var numberOfRows: Int {
        results.count
    }
    var heightForRow: CGFloat {
        isFlag ? 70 : 95
    }
    
    private let mode: Setting
    private let game: Games
    private let results: [Incorrects]
    private let favourites: [Favourites]
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    
    required init(mode: Setting, game: Games, results: [Incorrects],
                  favourites: [Favourites]) {
        self.mode = mode
        self.game = game
        self.results = results
        self.favourites = favourites
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func customCell(cell: UITableViewCell, indexPath: IndexPath) {
        if isFlag {
            flagCell(cell: cell as! FlagCell, indexPath: indexPath)
        } else {
            nameCell(cell: cell as! NameCell, indexPath: indexPath)
        }
    }
    
    func detailsViewModel(_ indexPath: Int) -> IncorrectViewModelProtocol {
        IncorrectViewModel(mode: mode, game: game, incorrect: results[indexPath], 
                           favourites: favourites)
    }
    // MARK: - Constants
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    private func flagCell(cell: FlagCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: results[indexPath.row].question.flag)
        cell.progressView.progress = setProgress(value: results[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = background
    }
    
    private func nameCell(cell: NameCell, indexPath: IndexPath) {
        cell.nameCountry.text = results[indexPath.row].question.name
        cell.progressView.progress = setProgress(value: results[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: results[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = background
    }
}
