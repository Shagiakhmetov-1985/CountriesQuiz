//
//  IncorrectViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 08.04.2024.
//

import UIKit

protocol IncorrectViewModelProtocol {
    var background: UIColor { get }
    var radius: CGFloat { get }
    var numberQuestion: String { get }
    var progress: Float { get }
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    var heightStackView: CGFloat { get }
    var favorites: [Favorites] { get }
    
    init(mode: Setting, game: Games, incorrect: Incorrects, favorites: [Favorites])
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func setBarButton(_ buttonBack: UIButton,_ buttonFavourites: UIButton,_ navigationItem: UINavigationItem)
    
    func question() -> UIView
    func view(_ button: Countries, addSubview: UIView, and tag: Int) -> UIView
    func subview(button: Countries, and tag: Int) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
    
    func widthStackView(_ view: UIView) -> CGFloat
    func imageFavorites() -> String
    
    func constraintsQuestion(_ subview: UIView, _ view: UIView)
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView,_ flag: String)
    func setSquare(_ buttons: UIButton..., sizes: CGFloat)
    func addOrDeleteFavorite(_ button: UIButton)
}

class IncorrectViewModel: IncorrectViewModelProtocol {
    var background: UIColor {
        game.background
    }
    let radius: CGFloat = 6
    var numberQuestion: String {
        "\(incorrect.currentQuestion) / \(mode.countQuestions)"
    }
    var progress: Float {
        Float(incorrect.currentQuestion) / Float(mode.countQuestions)
    }
    var buttonFirst: Countries {
        incorrect.buttonFirst
    }
    var buttonSecond: Countries {
        incorrect.buttonSecond
    }
    var buttonThird: Countries {
        incorrect.buttonThird
    }
    var buttonFourth: Countries {
        incorrect.buttonFourth
    }
    var heightStackView: CGFloat {
        isFlag ? 215 : 235
    }
    
    var favorites: [Favorites]
    private let mode: Setting
    private let game: Games
    private let incorrect: Incorrects
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    private var flag: String {
        incorrect.question.flag
    }
    private var name: String {
        incorrect.question.name
    }
    private var capital: String {
        incorrect.question.capitals
    }
    private var continent: String {
        setContinent()
    }
    private var answerFirst: String {
        buttonName(buttonFirst)
    }
    private var answerSecond: String {
        buttonName(buttonSecond)
    }
    private var answerThird: String {
        buttonName(buttonThird)
    }
    private var answerFourth: String {
        buttonName(buttonFourth)
    }
    private var newFavorite: Favorites {
        Favorites(flag: flag, name: name, capital: capital, continent: continent,
                  buttonFirst: answerFirst, buttonSecond: answerSecond,
                  buttonThird: answerThird, buttonFourth: answerFourth,
                  tag: incorrect.tag, isFlag: isFlag, isTimeUp: incorrect.timeUp)
    }
    private var key: String {
        game.keys
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
    
    required init(mode: Setting, game: Games, incorrect: Incorrects,
                  favorites: [Favorites]) {
        self.mode = mode
        self.game = game
        self.incorrect = incorrect
        self.favorites = favorites
    }
    // MARK: - Set subviews
    func setSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    func setBarButton(_ buttonBack: UIButton, _ buttonFavourites: UIButton,
                      _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        let rightBarButton = UIBarButtonItem(customView: buttonFavourites)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    // MARK: - Constants
    func widthStackView(_ view: UIView) -> CGFloat {
        isFlag ? view.bounds.width - 40 : view.bounds.width - 20
    }
    
    func imageFavorites() -> String {
        if let _ = favorites.first(where: { $0.flag == flag }) {
            "star.fill"
        } else {
            "star"
        }
    }
    // MARK: - Subviews
    func question() -> UIView {
        if isFlag {
            setImage(image: UIImage(named: flag))
        } else {
            setLabel(text: name, size: 32, color: .white)
        }
    }
    
    func view(_ button: Countries, addSubview: UIView, and tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor(button, tag)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(subview: addSubview, on: view, and: button, tag: tag)
        return view
    }
    
    func subview(button: Countries, and tag: Int) -> UIView {
        if isFlag {
            setLabel(text: text(button), size: 23, color: textColor(button, tag))
        } else {
            setSubview(button: button, tag: tag)
        }
    }
    
    func stackView(_ first: UIView, _ second: UIView, 
                   _ third: UIView, _ fourth: UIView) -> UIStackView {
        if isFlag {
            setStackView(first, second, third, fourth)
        } else {
            checkGameType(first, second, third, fourth)
        }
    }
    // MARK: - Set constraints
    func constraintsQuestion(_ subview: UIView, _ view: UIView) {
        if isFlag {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: width(flag)),
                subview.heightAnchor.constraint(equalToConstant: 168)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthStackView(view))
            ])
        }
    }
    
    func setConstraints(_ subview: UIView, on button: UIView, _ view: UIView,
                        _ flag: String) {
        if isFlag {
            let constant: CGFloat = game.gameType == .questionnaire ? 50 : 20
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                layoutConstraint(subview: subview, on: button, view),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(flag, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
    }
    
    func setSquare(_ buttons: UIButton..., sizes: CGFloat) {
        buttons.forEach { button in
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: sizes),
                button.heightAnchor.constraint(equalToConstant: sizes)
            ])
        }
    }
    
    func addOrDeleteFavorite(_ button: UIButton) {
        let pointSize: CGFloat = button.tag == 1 ? 33 : 20
        let size = UIImage.SymbolConfiguration(pointSize: pointSize)
        let currentImage = button.currentImage?.withConfiguration(size)
        let image = UIImage(systemName: "star", withConfiguration: size)
        let bool = currentImage == image ? true : false
        setButton(button, isFill: bool)
        setFavorites(isFill: bool)
    }
}
// MARK: - Private methods, constants
extension IncorrectViewModel {
    private func textColor(_ button: Countries, _ tag: Int) -> UIColor {
        flag == button.flag ? correctTextColor() : incorrectTextColor(tag)
    }
    
    private func correctTextColor() -> UIColor {
        game.gameType == .questionnaire ? .greenHarlequin : .white
    }
    
    private func incorrectTextColor(_ tag: Int) -> UIColor {
        incorrect.tag == tag ? checkSelectText() : checkNotSelectText()
    }
    
    private func checkSelectText() -> UIColor {
        game.gameType == .questionnaire ? .redTangerineTango : .white
    }
    
    private func checkNotSelectText() -> UIColor {
        game.gameType == .questionnaire ? .white : .grayLight
    }
    
    private func backgroundColor(_ button: Countries, _ tag: Int) -> UIColor {
        flag == button.flag ? correctBackground() : incorrectBackground(tag)
    }
    
    private func correctBackground() -> UIColor {
        game.gameType == .questionnaire ? .white : .greenYellowBrilliant
    }
    
    private func incorrectBackground(_ tag: Int) -> UIColor {
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
    
    private func checkmark(_ button: Countries, _ tag: Int) -> String {
        flag == button.flag ? "checkmark.circle.fill" : incorrectCheckmark(tag)
    }
    
    private func incorrectCheckmark(_ tag: Int) -> String {
        incorrect.tag == tag ? "xmark.circle.fill" : "circle"
    }
    
    private func color(_ button: Countries, _ tag: Int) -> UIColor {
        flag == button.flag ? .greenHarlequin : incorrectColor(tag)
    }
    
    private func incorrectColor(_ tag: Int) -> UIColor {
        incorrect.tag == tag ? .redTangerineTango : .white
    }
    
    private func text(_ button: Countries) -> String {
        game.gameType == .quizOfCapitals ? button.capitals : button.name
    }
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        if game.gameType == .questionnaire {
            return buttonWidth - 45
        } else {
            return buttonWidth - 10
        }
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = heightStackView / 2 - 4
        return buttonHeight - 10
    }
    
    private func widthImage(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
    
    private func setContinent() -> String {
        search(continents: americanContinent, europeanContinent,
               africanContinent, asianContinent, oceanContinent)
    }
    
    private func search(continents: [String]...) -> String {
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
}
// MARK: - Set subviews
extension IncorrectViewModel {
    private func addSubviews(subview: UIView, on view: UIView,
                             and button: Countries, tag: Int) {
        if game.gameType == .questionnaire {
            let checkmark = setCheckmark(image: checkmark(button, tag),
                                         color: color(button, tag))
            setSubviews(subviews: checkmark, subview, on: view)
            setConstraints(checkmark: checkmark, on: view)
        } else {
            setSubviews(subviews: subview, on: view)
        }
    }
    
    private func setSubview(button: Countries, tag: Int) -> UIView {
        if game.gameType == .quizOfCapitals {
            setLabel(text: button.capitals, size: 23, color: textColor(button, tag))
        } else {
            setImage(image: UIImage(named: button.flag))
        }
    }
    
    private func setImage(image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = isFlag ? 0 : 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setCheckmark(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func setLabel(text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              _ third: UIView, _ fourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 8
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
}
// MARK: - Private methods, constraints
extension IncorrectViewModel {
    private func setConstraints(checkmark: UIImageView, on view: UIView) {
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        ])
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
    
    private func buttonName(_ button: Countries) -> String {
        switch game.gameType {
        case .quizOfCapitals: button.capitals
        default: isFlag ? button.name : button.flag
        }
    }
}
// MARK: - Add or delete favorites
extension IncorrectViewModel {
    private func setButton(_ button: UIButton, isFill: Bool) {
        let pointSize: CGFloat = button.tag == 1 ? 33 : 20
        let systemName = isFill ? "star.fill" : "star"
        let size = UIImage.SymbolConfiguration(pointSize: pointSize)
        let setImage = UIImage(systemName: systemName, withConfiguration: size)
        button.setImage(setImage, for: .normal)
    }
    
    private func setFavorites(isFill: Bool) {
        if isFill {
            favorites.append(newFavorite)
            StorageManager.shared.addFavorite(favorite: newFavorite, key: key)
        } else {
            guard let index = favorites.firstIndex(where: { $0.flag == flag }) else { return }
            favorites.remove(at: index)
            StorageManager.shared.deleteFavorite(favorite: index, key: key)
        }
    }
}
