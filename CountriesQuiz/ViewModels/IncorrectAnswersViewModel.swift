//
//  IncorrectAnswersViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.04.2024.
//

import UIKit

protocol IncorrectAnswersViewModelProtocol {
    var backgroundLight: UIColor { get }
    var backgroundMedium: UIColor { get }
    var backgroundDark: UIColor { get }
    var title: String { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightForRow: CGFloat { get }
    var favorites: [Favorites] { get }
    
    init(mode: Setting, game: Games, results: [Incorrects], favourites: [Favorites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    func setView(color: UIColor, radius: CGFloat) -> UIView
    func setLabel(title: String, color: UIColor, size: CGFloat) -> UILabel
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView
    func setDetails(_ viewDetails: UIView,_ view: UIView, and indexPath: IndexPath)
    func setFavorites(newFavorites: [Favorites])
    
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(_ button: UIButton,_ moreInfo: UIButton, on view: UIView)
    func setConstraints(_ label: UILabel, and image: UIImageView, on view: UIView)
    
    func detailsViewModel(_ indexPath: Int) -> IncorrectViewModelProtocol
}

class IncorrectAnswersViewModel: IncorrectAnswersViewModelProtocol {
    var backgroundLight: UIColor {
        game.background
    }
    var backgroundMedium: UIColor {
        game.favorite
    }
    var backgroundDark: UIColor {
        game.swap
    }
    var title: String = "Неправильные ответы"
    var cell: AnyClass {
        isFlag ? FlagCell.self : NameCell.self
    }
    var numberOfRows: Int {
        incorrects.count
    }
    var heightForRow: CGFloat {
        isFlag ? 70 : 95
    }
    
    var favorites: [Favorites]
    private let mode: Setting
    private let game: Games
    private let incorrects: [Incorrects]
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    private var radius: CGFloat = 5
    private var heightProgressView: CGFloat {
        radius * 2
    }
    private var heightStackView: CGFloat {
        isFlag ? 205 : 225
    }
    
    private var viewSecondary: UIView!
    private var subview: UIView!
    private var progressView: UIProgressView!
    private var labelNumber: UILabel!
    private var stackView: UIStackView!
    private var timeUp: UILabel!
    
    required init(mode: Setting, game: Games, results: [Incorrects],
                  favourites: [Favorites]) {
        self.mode = mode
        self.game = game
        self.incorrects = results
        self.favorites = favourites
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
    
    func setView(color: UIColor, radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setLabel(title: String, color: UIColor, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func setDetails(_ viewDetails: UIView, _ view: UIView, and indexPath: IndexPath) {
        let incorrect = incorrects[indexPath.row]
        viewSecondary = setView(color: backgroundLight, radius: 0)
        subview = setName(incorrect: incorrect)
        progressView = setProgressView(incorrect: incorrect)
        labelNumber = setLabel(title: setText(value: incorrect.currentQuestion), color: .white, size: 22)
        stackView = 
    }
    
    func setFavorites(newFavorites: [Favorites]) {
        favorites = newFavorites
    }
    
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: sizes),
            button.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func setConstraints(_ button: UIButton, _ moreInfo: UIButton, on view: UIView) {
        setSquare(button: button, sizes: 40)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            moreInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moreInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moreInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moreInfo.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setConstraints(_ label: UILabel, and image: UIImageView, on view: UIView) {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func detailsViewModel(_ indexPath: Int) -> IncorrectViewModelProtocol {
        IncorrectViewModel(mode: mode, game: game, incorrect: incorrects[indexPath], 
                           favorites: favorites)
    }
}
// MARK: - Constants
extension IncorrectAnswersViewModel {
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    private func flagCell(cell: FlagCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: incorrects[indexPath.row].question.flag)
        cell.progressView.progress = setProgress(value: incorrects[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: incorrects[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = backgroundLight
    }
    
    private func nameCell(cell: NameCell, indexPath: IndexPath) {
        cell.nameCountry.text = incorrects[indexPath.row].question.name
        cell.progressView.progress = setProgress(value: incorrects[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: incorrects[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = backgroundLight
    }
    
    private func background(incorrect: Incorrects, name: String) -> UIColor {
        title(incorrect.question) == name ? correctBackground() : notSelectBackground()
    }
    
    private func correctBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlags, .quizOfCapitals: .greenYellowBrilliant
        default: .white
        }
    }
    
    private func notSelectBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlags: isFlag ? .whiteAlpha : .skyGrayLight
        case .questionnaire: .greenHarlequin
        default: .whiteAlpha
        }
    }
    
    private func textColor(incorrect: Incorrects, _ name: String, and tag: Int) -> UIColor {
        title(incorrect.question) == name ? correctTextColor() : notSelectTextColor()
    }
    
    private func correctTextColor() -> UIColor {
        game.gameType == .questionnaire ? .greenHarlequin : .white
    }
    
    private func notSelectTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlags, .quizOfCapitals: .grayLight
        default: .white
        }
    }
    
    private func checkmark(_ incorrect: Incorrects, _ name: String,
                           _ tag: Int) -> String {
        title(incorrect.question) == name ? "checkmark.circle.fill" : incorrectCheckmark(incorrect, tag)
    }
    
    private func incorrectCheckmark(_ incorrect: Incorrects, _ tag: Int) -> String {
        incorrect.tag == tag ? "xmark.circle.fill" : "circle"
    }
    
    private func color(_ incorrect: Incorrects, _ name: String,
                       _ tag: Int) -> UIColor {
        title(incorrect.question) == name ? .greenHarlequin : incorrectColor(incorrect, tag)
    }
    
    private func incorrectColor(_ incorrect: Incorrects, _ tag: Int) -> UIColor {
        incorrect.tag == tag ? .redTangerineTango : .white
    }
    
    private func title(_ name: Countries) -> String {
        switch game.gameType {
        case .quizOfCapitals: name.capitals
        default: isFlag ? name.name : name.flag
        }
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 49) / 2
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 49) / 2
        if game.gameType == .questionnaire {
            return buttonWidth - 45
        } else {
            return buttonWidth - 10
        }
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = (heightStackView - 4) / 2
        return buttonHeight - 10
    }
    
    private func widthImage(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
}
// MARK: - Subviews
extension IncorrectAnswersViewModel {
    private func setName(incorrect: Incorrects) -> UIView {
        if isFlag {
            setImage(image: incorrect.question.flag)
        } else {
            setLabel(title: incorrect.question.name, color: .white, size: 28)
        }
    }
    
    private func setImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setProgressView(incorrect: Incorrects) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progress = setProgress(value: incorrect.currentQuestion)
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
    
    private func setStackView(incorrect: Incorrects, and view: UIView) -> UIStackView {
        
    }
    
    private func setView(incorrect: Incorrects, _ name: String, _ tag: Int,
                         and view: UIView) -> UIView {
        let background = background(incorrect: incorrect, name: name)
        let button = setView(color: background, radius: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        addSubviews(incorrect: incorrect, name, button, and: tag, view)
        return button
    }
    
    private func addSubviews(incorrect: Incorrects, _ name: String, 
                             _ button: UIView, and tag: Int, _ view: UIView) {
        if game.gameType == .questionnaire {
            let subview = subview(incorrect: incorrect, and: name)
            let checkmark = setImage(image: checkmark(incorrect, name, tag),
                                     color: color(incorrect, name, tag), size: 26)
            setupSubviews(subviews: subview, checkmark, on: button)
            setConstraints(checkmark, and: subview, on: button, name, view)
        } else {
            let subview = subview(incorrect: incorrect, and: name)
            setupSubviews(subviews: subview, on: button)
            setConstraints(subview, on: button, name, view)
        }
    }
    
    private func subview(incorrect: Incorrects, and name: String) -> UIView {
        if isFlag {
            let color = textColor(incorrect: incorrect, name: name)
            
        } else {
            
        }
    }
    
    private func setSubview(_ name: String, and tag: Int) -> UIView {
        if game.gameType == .quizOfCapitals {
            
        } else {
            
        }
    }
}
// MARK: - Constraints
extension IncorrectAnswersViewModel {
    private func setConstraints(_ checkmark: UIImageView, and subview: UIView,
                                on button: UIView, _ name: String, _ view: UIView) {
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant)
        ])
        setConstraints(subview, on: button, name, view)
    }
    
    private func setConstraints(_ subview: UIView, on button: UIView,
                                _ name: String, _ view: UIView) {
        if isFlag {
            let constant: CGFloat = isFlag ? 40 : 10
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                layoutConstraint(subview: subview, on: button, view),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(name, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
    }
    
    private func layoutConstraint(subview: UIView, on button: UIView, 
                                  _ view: UIView) -> NSLayoutConstraint {
        if game.gameType == .questionnaire {
            let center = setCenter(view)
            return subview.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: center)
        } else {
            return subview.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        }
    }
}
