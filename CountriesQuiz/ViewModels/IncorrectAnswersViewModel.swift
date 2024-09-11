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
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    func setView(color: UIColor, radius: CGFloat) -> UIView
    func setLabel(title: String, color: UIColor, size: CGFloat) -> UILabel
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView
    func setButtonFavorite(_ button: UIButton, and indexPath: IndexPath)
    func setDetails(_ viewDetails: UIView,_ view: UIView, and indexPath: IndexPath)
    func setFavorites(newFavorites: [Favorites])
    
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(_ button: UIButton,_ moreInfo: UIButton, on view: UIView)
    func setConstraints(_ label: UILabel, and image: UIImageView, on view: UIView)
    func setConstraints(_ viewDetails: UIView, and button: UIButton, on view: UIView,_ indexPath: IndexPath)
    
    func buttonOnOff(button: UIButton, isOn: Bool)
    func showAnimationView(_ viewDetails: UIView, _ button: UIButton, and visualEffect: UIVisualEffectView)
    func hideAnimationView(_ viewDetails: UIView, _ button: UIButton, and visualEffect: UIVisualEffectView)
    func addOrDeleteFavorite(_ button: UIButton)
    
    func detailsViewModel() -> IncorrectViewModelProtocol
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
    
    private var indexPath: IndexPath!
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
    private var americanContinent: [String] {
        FlagsOfCountries.shared.imagesOfAmericanContinent
    }
    private var europeanContinent: [String] {
        FlagsOfCountries.shared.imagesOfEuropeanContinent
    }
    private var africanContinent: [String] {
        FlagsOfCountries.shared.imagesOfAfricanContinent
    }
    private var asianContinent: [String] {
        FlagsOfCountries.shared.imagesOfAsianContinent
    }
    private var oceanContinent: [String] {
        FlagsOfCountries.shared.imagesOfOceanContinent
    }
    private var key: String {
        game.keys
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
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
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
    
    func setButtonFavorite(_ button: UIButton, and indexPath: IndexPath) {
        let flag = incorrects[indexPath.row].question.flag
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: setImage(flag), withConfiguration: size)
        button.setImage(image, for: .normal)
    }
    
    func setDetails(_ viewDetails: UIView, _ view: UIView, and indexPath: IndexPath) {
        let incorrect = setIndexPath(index: indexPath)
        viewSecondary = setView(color: backgroundLight, radius: 0)
        subview = setName(incorrect: incorrect)
        progressView = setProgressView(incorrect: incorrect)
        labelNumber = setLabel(title: setText(value: incorrect.currentQuestion), color: .white, size: 22)
        stackView = setStackView(incorrect: incorrect, and: view)
        timeUp = setLabel(title: title(incorrect), color: .white, size: 22)
        setSubviews(subviews: viewSecondary, on: viewDetails)
        setSubviews(subviews: subview, progressView, labelNumber, stackView, timeUp, on: viewSecondary)
        setConstraints(incorrect: incorrect, on: viewDetails)
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
    
    func setConstraints(_ viewDetails: UIView, and button: UIButton,
                        on view: UIView, _ indexPath: IndexPath) {
        let constant: CGFloat = constant(incorrect: incorrects[indexPath.row])
        NSLayoutConstraint.activate([
            viewDetails.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewDetails.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: constant),
            viewDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            viewDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: viewDetails.bottomAnchor, constant: 25)
        ])
    }
    
    func buttonOnOff(button: UIButton, isOn: Bool) {
        let opacity: Float = isOn ? 1 : 0
        isEnabled(buttons: button, isOn: isOn)
        setOpacityButtons(buttons: button, opacity: opacity)
    }
    
    func showAnimationView(_ viewDetails: UIView, _ button: UIButton,
                           and visualEffect: UIVisualEffectView) {
        transform(subviews: viewDetails, button, transform: CGAffineTransform(scaleX: 0.6, y: 0.6))
        alpha(subviews: viewDetails, button, alpha: 0)
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: visualEffect, viewDetails, button, alpha: 1)
            transform(subviews: viewDetails, button, transform: .identity)
        }
    }
    
    func hideAnimationView(_ viewDetails: UIView, _ button: UIButton,
                           and visualEffect: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: visualEffect, viewDetails, button, alpha: 0)
            transform(subviews: viewDetails, button, transform: CGAffineTransform(scaleX: 0.6, y: 0.6))
        } completion: { [self] _ in
            removeSubviews(subviews: viewDetails, viewSecondary, subview,
                           progressView, labelNumber, stackView, timeUp)
        }
    }
    
    func addOrDeleteFavorite(_ button: UIButton) {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let currentImage = button.currentImage?.withConfiguration(size)
        let image = UIImage(systemName: "star", withConfiguration: size)
        let isFill = currentImage == image ? true : false
        setButton(button, isFill)
        setFavorite(isFill: isFill)
    }
    
    func detailsViewModel() -> IncorrectViewModelProtocol {
        IncorrectViewModel(mode: mode, game: game, incorrect: incorrects[indexPath.row],
                           favorites: favorites)
    }
}
// MARK: - Constants
extension IncorrectAnswersViewModel {
    private func setIndexPath(index: IndexPath) -> Incorrects {
        indexPath = index
        return incorrects[indexPath.row]
    }
    
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
    
    private func background(_ incorrect: Incorrects,_ name: String, 
                            and tag: Int) -> UIColor {
        title(incorrect.question) == name ? correctBackground() : incorrectBackground(incorrect, tag)
    }
    
    private func correctBackground() -> UIColor {
        game.gameType == .questionnaire ? .white : .greenYellowBrilliant
    }
    
    private func incorrectBackground(_ incorrect: Incorrects, _ tag: Int) -> UIColor {
        incorrect.tag == tag ? checkSelect() : checkNotSelect()
    }
    
    private func checkSelect() -> UIColor {
        switch game.gameType {
        case .quizOfFlags: .redTangerineTango
        case .questionnaire: .white
        default: .bismarkFuriozo
        }
    }
    
    private func checkNotSelect() -> UIColor {
        switch game.gameType {
        case .quizOfFlags: isFlag ? .whiteAlpha : .skyGrayLight
        case .questionnaire: .greenHarlequin
        default: .whiteAlpha
        }
    }
    
    private func textColor(_ incorrect: Incorrects, _ name: String, 
                           and tag: Int) -> UIColor {
        title(incorrect.question) == name ? correctTextColor() : notSelectTextColor(incorrect, tag)
    }
    
    private func correctTextColor() -> UIColor {
        game.gameType == .questionnaire ? .greenHarlequin : .white
    }
    
    private func notSelectTextColor(_ incorrect: Incorrects, _ tag: Int) -> UIColor {
        incorrect.tag == tag ? checkSelectText() : checkNotSelectText()
    }
    
    private func checkSelectText() -> UIColor {
        game.gameType == .questionnaire ? .redTangerineTango : .white
    }
    
    private func checkNotSelectText() -> UIColor {
        game.gameType == .questionnaire ? .white : .grayLight
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
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 140
        default: return 234
        }
    }
    
    private func title(_ incorrect: Incorrects) -> String {
        incorrect.timeUp ? "Время вышло!" : ""
    }
    
    private func constant(incorrect: Incorrects) -> CGFloat {
        (isFlag ? 0.66 : 0.56) + name(incorrect) + timeUp(incorrect)
    }
    
    private func name(_ incorrect: Incorrects) -> CGFloat {
        isFlag ? 0 : incorrect.question.name.count > 23 ? 0.035 : 0
    }
    
    private func timeUp(_ incorrect: Incorrects) -> CGFloat {
        isTimeUp() ? 0.035 : 0
    }
    
    private func setImage(_ flag: String) -> String {
        if let _ = favorites.first(where: { $0.flag == flag }) {
            "star.fill"
        } else {
            "star"
        }
    }
    
    private func continent() -> String {
        search(continents: americanContinent, europeanContinent,
               africanContinent, asianContinent, oceanContinent)
    }
    
    private func search(continents: [String]...) -> String {
        let flag = incorrects[indexPath.row].question.flag
        var setContinent = String()
        var counter = 0
        for continent in continents {
            if continent.contains(where: { $0 == flag }) {
                setContinent = getContinent(counter: counter)
                break
            }
            counter += 1
        }
        return setContinent
    }
    
    private func getContinent(counter: Int) -> String {
        switch counter {
        case 0: "Континент Америки"
        case 1: "Континент Европы"
        case 2: "Континент Африки"
        case 3: "Континент Азии"
        default: "Континент Океании"
        }
    }
    
    private func flag() -> String {
        incorrects[indexPath.row].question.flag
    }
    
    private func name() -> String {
        incorrects[indexPath.row].question.name
    }
    
    private func capital() -> String {
        incorrects[indexPath.row].question.capitals
    }
    
    private func answerFirst() -> String {
        title(incorrects[indexPath.row].buttonFirst)
    }
    
    private func answerSecond() -> String {
        title(incorrects[indexPath.row].buttonSecond)
    }
    
    private func answerThird() -> String {
        title(incorrects[indexPath.row].buttonThird)
    }
    
    private func answerFourth() -> String {
        title(incorrects[indexPath.row].buttonFourth)
    }
    
    private func tag() -> Int {
        incorrects[indexPath.row].tag
    }
    
    private func isTimeUp() -> Bool {
        incorrects[indexPath.row].timeUp
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
        let first = setView(incorrect, title(incorrect.buttonFirst), 1, and: view)
        let second = setView(incorrect, title(incorrect.buttonSecond), 2, and: view)
        let third = setView(incorrect, title(incorrect.buttonThird), 3, and: view)
        let fourth = setView(incorrect, title(incorrect.buttonFourth), 4, and: view)
        if isFlag {
            return setStackView(first, second, third, fourth)
        } else {
            return checkGameType(first, second, third, fourth)
        }
    }
    
    private func setStackView(_ first: UIView, _ second: UIView, 
                              _ third: UIView, _ fourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func checkGameType(_ first: UIView, _ second: UIView,
                               _ third: UIView, _ fourth: UIView) -> UIStackView {
        if game.gameType == .quizOfCapitals {
            return setStackView(first, second, third, fourth)
        } else {
            let stackViewOne = setStackView(first, second)
            let stackViewTwo = setStackView(third, fourth)
            return setStackView(stackViewOne, stackViewTwo, axis: .vertical)
        }
    }
    
    private func setView(_ incorrect: Incorrects, _ name: String, _ tag: Int,
                         and view: UIView) -> UIView {
        let background = background(incorrect, name, and: tag)
        let button = setView(color: background, radius: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        addSubviews(incorrect: incorrect, name, button, and: tag, view)
        return button
    }
    
    private func addSubviews(incorrect: Incorrects, _ name: String, 
                             _ button: UIView, and tag: Int, _ view: UIView) {
        if game.gameType == .questionnaire {
            let subview = subview(incorrect, name, and: tag)
            let checkmark = setImage(image: checkmark(incorrect, name, tag),
                                     color: color(incorrect, name, tag), size: 26)
            setSubviews(subviews: subview, checkmark, on: button)
            setConstraints(checkmark, and: subview, on: button, name, view)
        } else {
            let subview = subview(incorrect, name, and: tag)
            setSubviews(subviews: subview, on: button)
            setConstraints(subview, on: button, name, view)
        }
    }
    
    private func subview(_ incorrect: Incorrects, _ name: String, 
                         and tag: Int) -> UIView {
        if isFlag {
            let color = textColor(incorrect, name, and: tag)
            return setLabel(title: name, color: color, size: 21)
        } else {
            return setSubview(incorrect, name, and: tag)
        }
    }
    
    private func setSubview(_ incorrect: Incorrects, _ name: String,
                            and tag: Int) -> UIView {
        if game.gameType == .quizOfCapitals {
            let color = textColor(incorrect, name, and: tag)
            return setLabel(title: name, color: color, size: 21)
        } else {
            return setImage(image: name, radius: 8)
        }
    }
}
// MARK: - Show / hide subviews
extension IncorrectAnswersViewModel {
    private func isEnabled(buttons: UIButton..., isOn: Bool) {
        buttons.forEach { button in
            button.isEnabled = isOn
        }
    }
    
    private func setOpacityButtons(buttons: UIButton..., opacity: Float) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.5) {
                button.layer.opacity = opacity
            }
        }
    }
    
    private func transform(subviews: UIView..., transform: CGAffineTransform) {
        subviews.forEach { subview in
            subview.transform = transform
        }
    }
    
    private func alpha(subviews: UIView..., alpha: CGFloat) {
        subviews.forEach { subview in
            subview.alpha = alpha
        }
    }
    
    private func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
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
            let constant: CGFloat = game.gameType == .questionnaire ? 40 : 10
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
    
    private func setConstraints(incorrect: Incorrects, on view: UIView) {
        NSLayoutConstraint.activate([
            viewSecondary.topAnchor.constraint(equalTo: view.topAnchor, constant: 52),
            viewSecondary.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSecondary.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewSecondary.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -53)
        ])
        
        if isFlag {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.centerXAnchor.constraint(equalTo: viewSecondary.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: width(incorrect.question.flag)),
                subview.heightAnchor.constraint(equalToConstant: 140)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 10),
                subview.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -10)
            ])
        }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: subview.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: heightProgressView)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 15),
            labelNumber.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -10),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        let constant: CGFloat = isFlag ? 15 : 7.5
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            stackView.heightAnchor.constraint(equalToConstant: heightStackView)
        ])
        
        NSLayoutConstraint.activate([
            timeUp.centerXAnchor.constraint(equalTo: viewSecondary.centerXAnchor),
            timeUp.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
    }
}
// MARK: - Add or delete favorite
extension IncorrectAnswersViewModel {
    private func setButton(_ button: UIButton, _ isFill: Bool) {
        let systemName = isFill ? "star.fill" : "star"
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: systemName, withConfiguration: size)
        button.setImage(image, for: .normal)
    }
    
    private func setFavorite(isFill: Bool) {
        if isFill {
            favorites.append(newFavorite())
            StorageManager.shared.addFavorite(favorite: newFavorite(), key: key)
        } else {
            guard let index = favorites.firstIndex(where: { $0.flag == flag() }) else { return }
            favorites.remove(at: index)
            StorageManager.shared.deleteFavorite(favorite: index, key: key)
        }
    }
    
    private func newFavorite() -> Favorites {
        Favorites(flag: flag(), name: name(), capital: capital(), continent: continent(),
                  buttonFirst: answerFirst(), buttonSecond: answerSecond(),
                  buttonThird: answerThird(), buttonFourth: answerFourth(),
                  tag: tag(), isFlag: isFlag, isTimeUp: isTimeUp())
    }
}
