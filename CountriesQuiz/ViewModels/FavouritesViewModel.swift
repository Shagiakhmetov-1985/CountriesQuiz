//
//  FavouritesViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.08.2024.
//

import UIKit

protocol FavouritesViewModelProtocol {
    var background: UIColor { get }
    var backgroundDetails: UIColor { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    
    init(game: Games, favourites: [Favourites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: FavouritesCell, indexPath: IndexPath)
    func setFavourites(newFavourites: [Favourites])
    func setView(color: UIColor, radius: CGFloat) -> UIView
    func setLabel(title: String, font: String, size: CGFloat, color: UIColor) -> UILabel
    func setImage(image: String) -> UIImageView
    func showDetails(_ viewDetails: UIView,_ view: UIView, and indexPath: IndexPath)
    
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(_ button: UIButton,_ view: UIView)
    
    func detailsViewController(_ indexPath: IndexPath) -> DetailsViewModelProtocol
}

class FavouritesViewModel: FavouritesViewModelProtocol {
    var background: UIColor {
        game.favourite
    }
    var backgroundDetails: UIColor {
        game.swap
    }
    var cell: AnyClass = FavouritesCell.self
    var numberOfRows: Int {
        favourites.count
    }
    var heightOfRow: CGFloat = 60
    
    private let game: Games
    private var favourites: [Favourites]
    
    private var viewSecondary: UIView!
    private var title: UILabel!
    private var name: UIView!
    private var stackView: UIStackView!
    
    required init(game: Games, favourites: [Favourites]) {
        self.game = game
        self.favourites = favourites
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let barButtom = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtom
    }
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func customCell(cell: FavouritesCell, indexPath: IndexPath) {
        cell.flag.image = UIImage(named: favourites[indexPath.row].flag)
        cell.name.text = favourites[indexPath.row].name
        cell.contentView.backgroundColor = background
    }
    
    func setFavourites(newFavourites: [Favourites]) {
        favourites = newFavourites
    }
    
    func detailsViewController(_ indexPath: IndexPath) -> DetailsViewModelProtocol {
        DetailsViewModel(game: game, favourite: favourites[indexPath.row], favourites: favourites)
    }
    
    func setView(color: UIColor, radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setLabel(title: String, font: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: font, size: size)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setImage(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func showDetails(_ viewDetails: UIView, _ view: UIView, and indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        viewSecondary = setView(color: game.background, radius: 15)
        title = setLabel(title: "Ошибка ответа", font: "GillSans", size: 22, color: .white)
        name = setName(favourite: favourite)
        stackView = setStackView(favourite, view)
        setSubviews(subviews: name, stackView, on: viewSecondary)
    }
    
    // MARK: - Constraints
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: sizes),
            button.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func setConstraints(_ button: UIButton, _ view: UIView) {
        setSquare(button: button, sizes: 40)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 12.5),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.5)
        ])
    }
}
// MARK: - Subviews
extension FavouritesViewModel {
    private func setName(favourite: Favourites) -> UIView {
        if favourite.isFlag {
            setImage(image: favourite.flag)
        } else {
            setLabel(title: favourite.name, font: "mr_fontick", size: 28, color: .white)
        }
    }
    
    private func setStackView(_ favourite: Favourites, _ view: UIView) -> UIStackView {
        let first = setView(favourite, favourite.buttonFirst, and: favourite.tag, view: view)
        let second = setView(favourite, favourite.buttonSecond, and: favourite.tag, view: view)
        let third = setView(favourite, favourite.buttonThird, and: favourite.tag, view: view)
        let fourth = setView(favourite, favourite.buttonFourth, and: favourite.tag, view: view)
        if favourite.isFlag {
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
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 5
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
    
    private func setView(_ favourite: Favourites, _ name: String, 
                         and tag: Int, view: UIView) -> UIView {
        let background = backgroundColor(favourite, name, and: tag)
        let button = setView(color: background, radius: 12)
        addSubviews(button, favourite, name, and: tag, view)
        return button
    }
    
    private func addSubviews(_ button: UIView, _ favourite: Favourites, 
                             _ name: String, and tag: Int, _ view: UIView) {
        if game.gameType == .questionnaire {
            let subview = subview(favourite, name, and: tag)
            let checkmark = setCheckmark(image: checkmark(favourite, name, tag),
                                         color: color(favourite, name, tag))
            setSubviews(subviews: checkmark, subview, on: button)
            setConstraints(favourite: favourite, checkmark, and: subview, on: button, name, view)
        } else {
            let subview = subview(favourite, name, and: tag)
            setSubviews(subviews: subview, on: button)
            setConstraints(favourite: favourite, subview, on: button, name, view)
        }
    }
    
    private func subview(_ favourite: Favourites, _ name: String, 
                         and tag: Int) -> UIView {
        if favourite.isFlag {
            let color = textColor(favourite, name, and: tag)
            return setLabel(title: name, font: "mr_fontick", size: 21, color: color)
        } else {
            return setSubview(favourite, name, and: tag)
        }
    }
    
    private func setSubview(_ favourite: Favourites, _ name: String, 
                            and tag: Int) -> UIView {
        if game.gameType == .quizOfCapitals {
            let color = textColor(favourite, name, and: tag)
            return setLabel(title: name, font: "mr_fontick", size: 21, color: color)
        } else {
            return setImage(image: name)
        }
    }
    
    private func setCheckmark(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Constants
extension FavouritesViewModel {
    private func backgroundColor(_ favourite: Favourites, _ name: String, 
                                 and tag: Int) -> UIColor {
        question(favourite) == name ? correctBackground() : incorrectBackground(favourite, tag)
    }
    
    private func question(_ favourite: Favourites) -> String {
        switch game.gameType {
        case .quizOfCapitals: favourite.capital
        default: favourite.isFlag ? favourite.flag : favourite.name
        }
    }
    
    private func correctBackground() -> UIColor {
        game.gameType == .questionnaire ? .white : .greenYellowBrilliant
    }
    
    private func incorrectBackground(_ favourite: Favourites, _ tag: Int) -> UIColor {
        favourite.tag == tag ? checkSelect() : checkNotSelect(favourite)
    }
    
    private func checkSelect() -> UIColor {
        switch game.gameType {
        case .quizOfFlags: .redTangerineTango
        case .questionnaire: .white
        default: .bismarkFuriozo
        }
    }
    
    private func checkNotSelect(_ favourite: Favourites) -> UIColor {
        switch game.gameType {
        case .quizOfFlags: favourite.isFlag ? .whiteAlpha : .skyGrayLight
        case .questionnaire: .greenHarlequin
        default: .whiteAlpha
        }
    }
    
    private func textColor(_ favourite: Favourites, _ name: String, 
                           and tag: Int) -> UIColor {
        question(favourite) == name ? correctTextColor() : incorrectTextColor(favourite, tag)
    }
    
    private func correctTextColor() -> UIColor {
        game.gameType == .questionnaire ? .greenHarlequin : .white
    }
    
    private func incorrectTextColor(_ favourite: Favourites, _ tag: Int) -> UIColor {
        favourite.tag == tag ? checkSelectText() : checkNotSelectText()
    }
    
    private func checkSelectText() -> UIColor {
        game.gameType == .questionnaire ? .redTangerineTango : .white
    }
    
    private func checkNotSelectText() -> UIColor {
        game.gameType == .questionnaire ? .white : .grayLight
    }
    
    private func checkmark(_ favourite: Favourites, _ name: String,
                           _ tag: Int) -> String {
        favourite.flag == name ? "checkmark.circle.fill" : incorrectCheckmark(favourite, tag)
    }
    
    private func incorrectCheckmark(_ favourite: Favourites, _ tag: Int) -> String {
        favourite.tag == tag ? "xmark.circle.fill" : "circle"
    }
    
    private func color(_ favourite: Favourites, _ name: String,
                       _ tag: Int) -> UIColor {
        favourite.flag == name ? .greenHarlequin : incorrectColor(favourite, tag)
    }
    
    private func incorrectColor(_ favourite: Favourites, _ tag: Int) -> UIColor {
        favourite.tag == tag ? .redTangerineTango : .white
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 40
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        if game.gameType == .questionnaire {
            return buttonWidth - 40
        } else {
            return buttonWidth - 10
        }
    }
    
    private func setHeight(_ favourite: Favourites) -> CGFloat {
        let heightStackView: CGFloat = favourite.isFlag ? 215 : 235
        let buttonHeight = heightStackView / 2 - 4
        return buttonHeight - 10
    }
    
    private func widthImage(_ favourite: Favourites, _ flag: String, 
                            _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight(favourite)
        default: return setWidth(view)
        }
    }
}
// MARK: - Constraints
extension FavouritesViewModel {
    private func setConstraints(subview: UIView, on view: UIView) {
        NSLayoutConstraint.activate([
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    private func setConstraints(favourite: Favourites, _ checkmark: UIImageView,
                                and subview: UIView, on button: UIView, 
                                _ name: String, _ view: UIView) {
        let constant: CGFloat = favourite.isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant)
        ])
        setConstraints(favourite: favourite, subview, on: button, name, view)
    }
    
    private func setConstraints(favourite: Favourites, _ subview: UIView, 
                                on button: UIView, _ name: String, _ view: UIView) {
        if favourite.isFlag {
            let constant: CGFloat = game.gameType == .questionnaire ? 40 : 10
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                layoutConstraint(subview: subview, on: button, button),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(favourite, name, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight(favourite))
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
