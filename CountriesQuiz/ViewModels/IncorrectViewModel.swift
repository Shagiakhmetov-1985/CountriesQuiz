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
    var flag: String { get }
    var numberQuestion: String { get }
    var progress: Float { get }
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    var heightStackView: CGFloat { get }
    var favorites: [Favorites] { get }
    var title: String { get }
    var image: String { get }
    var name: String { get }
    var capital: String { get }
    var continent: String { get }
    var timeUp: String { get }
    var height: CGFloat { get }
    
    init(mode: Setting, game: Games, incorrect: Incorrects, favorites: [Favorites])
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func setBarButton(_ buttonBack: UIButton,_ navigationItem: UINavigationItem)
    
    func view(_ button: Countries, addSubview: UIView, and tag: Int) -> UIView
    func subview(button: Countries, and tag: Int) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
    func setView() -> UIView
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView
    func setView(addSubview: UIView) -> UIView
    func setView(_ viewFlag: UIView, and imageFlag: UIImageView) -> UIView
    func setView(subviews: UIView...) -> UIView
    func setLabel(text: String, color: UIColor, font: String, size: CGFloat) -> UILabel
    func setView(_ viewNumber: UIView, _ progressView: UIProgressView, and labelNumber: UILabel) -> UIView
    func setView(_ viewIcon: UIView, _ label: UILabel) -> UIView
    func setView(first: UIImageView, second: UIImageView) -> UIView
    func setView(_ viewIcons: UIView, _ stackView: UIStackView, and timeUp: UILabel) -> UIView
    
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView)
    func setSquare(_ buttons: UIButton..., sizes: CGFloat)
    func addOrDeleteFavorite(_ button: UIButton)
}

class IncorrectViewModel: IncorrectViewModelProtocol {
    var background: UIColor {
        game.swap
    }
    let radius: CGFloat = 6
    var flag: String {
        incorrect.question.flag
    }
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
        isFlag ? 205 : 225
    }
    var title: String {
        if let _ = favorites.first(where: { $0.flag == flag }) {
            "   Удалить из избранных"
        } else {
            "   Добавить в избранное"
        }
    }
    var image: String {
        if let _ = favorites.first(where: { $0.flag == flag }) {
            "star.fill"
        } else {
            "star"
        }
    }
    var name: String {
        incorrect.question.name
    }
    var capital: String {
        incorrect.question.capitals
    }
    var continent: String {
        setContinent()
    }
    var timeUp: String {
        incorrect.timeUp ? "Время вышло!" : ""
    }
    var height: CGFloat {
        heightStackView + constant + (incorrect.timeUp ? 44 : 0) + 10
    }
    
    var favorites: [Favorites]
    private let mode: Setting
    private let game: Games
    private let incorrect: Incorrects
    private var isFlag: Bool {
        mode.flag ? true : false
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
    private let constant: CGFloat = 58
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
    
    func setBarButton(_ buttonBack: UIButton, _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    // MARK: - Subviews
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
            setLabel(text: text(button), color: textColor(button, tag), font: "mr_fontick", size: 23)
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
    
    func setView() -> UIView {
        let view = UIView()
        view.backgroundColor = background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func setView(addSubview: UIView) -> UIView {
        let view = setView(color: game.favorite)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.addSubview(addSubview)
        setConstraints(subview: addSubview, on: view)
        return view
    }
    
    func setView(_ viewFlag: UIView, and imageFlag: UIImageView) -> UIView {
        let view = setView(color: game.background)
        setSubviews(subviews: viewFlag, imageFlag, on: view)
        setConstraints(viewFlag, and: imageFlag, on: view)
        return view
    }
    
    func setView(subviews: UIView...) -> UIView {
        let view = setView(color: background)
        subviews.forEach { subview in
            view.addSubview(subview)
        }
        return view
    }
    
    func setView(_ viewNumber: UIView, _ progressView: UIProgressView, 
                 and labelNumber: UILabel) -> UIView {
        let view = setView(color: game.background)
        setSubviews(subviews: viewNumber, progressView, labelNumber, on: view)
        setConstraints(viewNumber, progressView, and: labelNumber, on: view)
        return view
    }
    
    func setView(_ viewIcon: UIView, _ label: UILabel) -> UIView {
        let view = setView(color: game.background)
        setSubviews(subviews: viewIcon, label, on: view)
        setConstraints(viewIcon, and: label, on: view)
        return view
    }
    
    func setView(first: UIImageView, second: UIImageView) -> UIView {
        let view = setView(color: game.favorite)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setSubviews(subviews: first, second, on: view)
        setConstraints(first, and: second, on: view)
        return view
    }
    
    func setView(_ viewIcons: UIView, _ stackView: UIStackView, 
                 and timeUp: UILabel) -> UIView {
        let view = setView(color: game.background)
        setSubviews(subviews: viewIcons, stackView, timeUp, on: view)
        setConstraints(viewIcons, stackView, and: timeUp, on: view)
        return view
    }
    
    func setLabel(text: String, color: UIColor, font: String, 
                  size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont(name: font, size: size)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    // MARK: - Set constraints
    func setConstraints(_ subview: UIView, on button: UIView, _ view: UIView) {
        if isFlag {
            let constant: CGFloat = game.gameType == .questionnaire ? 50 : 20
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
        } else {
            let flag = flagName(subview)
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
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let currentImage = button.currentImage?.withConfiguration(size)
        let image = UIImage(systemName: "star", withConfiguration: size)
        let isOn = currentImage == image ? true : false
        setButton(button, isFill: isOn)
        setFavorites(isFill: isOn)
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
        case "nepal", "vatican city", "switzerland": return 134
        default: return 210
        }
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 34) / 2
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 34) / 2
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
    
    private func buttonName(_ button: Countries) -> String {
        switch game.gameType {
        case .quizOfCapitals: button.capitals
        default: isFlag ? button.name : button.flag
        }
    }
    
    private func flagName(_ subview: UIView) -> String {
        switch subview.tag {
        case 1: buttonFirst.flag
        case 2: buttonSecond.flag
        case 3: buttonThird.flag
        default: buttonFourth.flag
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
            setLabel(text: button.capitals, color: textColor(button, tag), font: "mr_fontick", size: 23)
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
    
    private func setView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private func setConstraints(subview: UIView, on view: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setConstraints(_ viewFlag: UIView, and imageFlag: UIImageView, 
                                on viewDetails: UIView) {
        NSLayoutConstraint.activate([
            viewFlag.topAnchor.constraint(equalTo: viewDetails.topAnchor),
            viewFlag.leadingAnchor.constraint(equalTo: viewDetails.leadingAnchor),
            viewFlag.bottomAnchor.constraint(equalTo: viewDetails.bottomAnchor),
            viewFlag.trailingAnchor.constraint(equalTo: viewDetails.leadingAnchor, constant: constant)
        ])
        
        NSLayoutConstraint.activate([
            imageFlag.centerXAnchor.constraint(equalTo: viewDetails.centerXAnchor, constant: constant / 2),
            imageFlag.centerYAnchor.constraint(equalTo: viewDetails.centerYAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: width(flag)),
            imageFlag.heightAnchor.constraint(equalToConstant: 134)
        ])
    }
    
    private func setConstraints(_ viewNumber: UIView, _ progressView: UIProgressView, 
                                and labelNumber: UILabel, on viewDetails: UIView) {
        NSLayoutConstraint.activate([
            viewNumber.topAnchor.constraint(equalTo: viewDetails.topAnchor),
            viewNumber.leadingAnchor.constraint(equalTo: viewDetails.leadingAnchor),
            viewNumber.bottomAnchor.constraint(equalTo: viewDetails.bottomAnchor),
            viewNumber.trailingAnchor.constraint(equalTo: viewDetails.leadingAnchor, constant: constant)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: viewDetails.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: viewNumber.trailingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: labelNumber.leadingAnchor, constant: -8),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: viewDetails.centerYAnchor),
            labelNumber.trailingAnchor.constraint(equalTo: viewDetails.trailingAnchor, constant: -10)
        ])
    }
    
    private func setConstraints(_ view: UIView, and label: UILabel, on viewDetails: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewDetails.topAnchor),
            view.leadingAnchor.constraint(equalTo: viewDetails.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: viewDetails.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: viewDetails.leadingAnchor, constant: constant)
        ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: viewDetails.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: viewDetails.trailingAnchor, constant: -10)
        ])
    }
    
    private func setConstraints(_ first: UIImageView, and second: UIImageView, 
                                on view: UIView) {
        NSLayoutConstraint.activate([
            first.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -21.5),
            first.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            second.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 21.5),
            second.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setConstraints(_ viewIcons: UIView, _ stackView: UIStackView, 
                                and timeUp: UILabel, on view: UIView) {
        NSLayoutConstraint.activate([
            viewIcons.topAnchor.constraint(equalTo: view.topAnchor),
            viewIcons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewIcons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewIcons.bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewIcons.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: heightStackView)
        ])
        
        NSLayoutConstraint.activate([
            timeUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeUp.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
    }
}
// MARK: - Add or delete favorites
extension IncorrectViewModel {
    private func setButton(_ button: UIButton, isFill: Bool) {
        let systemName = isFill ? "star.fill" : "star"
        let title = isFill ? "Удалить из избранных" : "Добавить в избранное"
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: systemName, withConfiguration: size)
        button.setImage(image, for: .normal)
        button.setTitle("   " + title, for: .normal)
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
