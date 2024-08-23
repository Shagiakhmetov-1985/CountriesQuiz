//
//  DetailsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 22.08.2024.
//

import UIKit

protocol DetailsViewModelProtocol {
    var background: UIColor { get }
    var titleFlag: String { get }
    var flag: String { get }
    var titleName: String { get }
    var name: String { get }
    var error: String { get }
    var buttonFirst: String { get }
    var buttonSecond: String { get }
    var buttonThird: String { get }
    var buttonFour: String { get }
    var titleButton: String { get }
    var backgroundButton: UIColor { get }
    var colorTitleButton: UIColor { get }
    var heightStackView: CGFloat { get }
    var favourites: [Favourites] { get }
    
    init(game: Games, favourite: Favourites, favourites: [Favourites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func setLabel(title: String, size: CGFloat, style: String, color: UIColor) -> UILabel
    func setView(_ title: String, addSubview: UIView, and tag: Int) -> UIView
    func subview(title: String, and tag: Int) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
    
    func widthStackView(_ view: UIView) -> CGFloat
    func width(_ image: String) -> CGFloat
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView,_ flag: String)
    
    func deleteAndBack()
}

class DetailsViewModel: DetailsViewModelProtocol {
    var background: UIColor {
        game.favourite
    }
    var titleFlag: String = "Флаг:"
    var flag: String {
        favourite.flag
    }
    var titleName: String = "Наименование:"
    var name: String {
        favourite.name
    }
    var error: String = "Ошибка ответа:"
    var buttonFirst: String {
        favourite.buttonFirst
    }
    var buttonSecond: String {
        favourite.buttonSecond
    }
    var buttonThird: String {
        favourite.buttonThird
    }
    var buttonFour: String {
        favourite.buttonFourth
    }
    var titleButton: String = "   Удалить из списка"
    var backgroundButton: UIColor {
        game.done
    }
    var colorTitleButton: UIColor {
        game.swap
    }
    var heightStackView: CGFloat {
        isFlag ? 215 : 235
    }
    
    var favourites: [Favourites]
    private let game: Games
    private let favourite: Favourites
    
    private var isFlag: Bool {
        favourite.isFlag
    }
    private var question: String {
        switch game.gameType {
        case .quizOfCapitals: favourite.capital
        default: isFlag ? name : flag
        }
    }
    
    required init(game: Games, favourite: Favourites, favourites: [Favourites]) {
        self.game = game
        self.favourite = favourite
        self.favourites = favourites
    }
    // MARK: - Subviews
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let button = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = button
    }
    
    func setSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    func setLabel(title: String, size: CGFloat, style: String, 
                  color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setView(_ title: String, addSubview: UIView, and tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor(title, tag)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(subview: addSubview, on: view, and: title, tag: tag)
        return view
    }
    
    func subview(title: String, and tag: Int) -> UIView {
        if isFlag {
            setLabel(title: title, size: 23, style: "mr_fontick", color: textColor(title, tag))
        } else {
            setSubview(title, tag)
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
    // MARK: - Constants
    func widthStackView(_ view: UIView) -> CGFloat {
        isFlag ? view.bounds.width - 40 : view.bounds.width - 20
    }
    
    func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    // MARK: - Constraints
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: sizes),
            button.heightAnchor.constraint(equalToConstant: sizes)
        ])
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
    // MARK: - Delete favourites and back to list
    func deleteAndBack() {
        guard let index = favourites.firstIndex(where: { $0.flag == flag }) else { return }
        favourites.remove(at: index)
        StorageManager.shared.deleteFavourite(favourite: index, key: game.keys)
    }
}
// MARK: - Private methods, constants
extension DetailsViewModel {
    private func backgroundColor(_ button: String, _ tag: Int) -> UIColor {
        question == button ? correctBackground() : incorrectBackground(tag)
    }
    
    private func correctBackground() -> UIColor {
        game.gameType == .questionnaire ? .white : .greenYellowBrilliant
    }
    
    private func incorrectBackground(_ tag: Int) -> UIColor {
        favourite.tag == tag ? checkSelect() : checkNotSelect()
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
    
    private func textColor(_ title: String, _ tag: Int) -> UIColor {
        question == title ? correctTextColor() : incorrectTextColor(tag)
    }
    
    private func correctTextColor() -> UIColor {
        game.gameType == .questionnaire ? .greenHarlequin : .white
    }
    
    private func incorrectTextColor(_ tag: Int) -> UIColor {
        favourite.tag == tag ? checkSelectText() : checkNotSelectText()
    }
    
    private func checkSelectText() -> UIColor {
        game.gameType == .questionnaire ? .redTangerineTango : .white
    }
    
    private func checkNotSelectText() -> UIColor {
        game.gameType == .questionnaire ? .white : .grayLight
    }
    
    private func checkmark(_ name: String, _ tag: Int) -> String {
        question == name ? "checkmark.circle.fill" : incorrectCheckmark(tag)
    }
    
    private func incorrectCheckmark(_ tag: Int) -> String {
        favourite.tag == tag ? "xmark.circle.fill" : "circle"
    }
    
    private func color(_ name: String, _ tag: Int) -> UIColor {
        question == name ? .greenHarlequin : incorrectColor(tag)
    }
    
    private func incorrectColor(_ tag: Int) -> UIColor {
        favourite.tag == tag ? .redTangerineTango : .white
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
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
}
// MARK: - Set subviews
extension DetailsViewModel {
    private func setSubview(_ title: String, _ tag: Int) -> UIView {
        if game.gameType == .quizOfCapitals {
            setLabel(title: title, size: 23, style: "mr_fontick", color: textColor(title, tag))
        } else {
            setImage(image: UIImage(named: title))
        }
    }
    
    private func addSubviews(subview: UIView, on view: UIView, and name: String,
                             tag: Int) {
        if game.gameType == .questionnaire {
            let checkmark = setCheckmark(image: checkmark(name, tag),
                                         color: color(name, tag))
            setSubviews(subviews: subview, checkmark, on: view)
            setConstraints(checkmark: checkmark, on: view)
        } else {
            setSubviews(subviews: subview, on: view)
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
        let stackView = UIStackView(arrangedSubviews: [first, second, third, fourth])
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
// MARK: - Constraints
extension DetailsViewModel {
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
}
