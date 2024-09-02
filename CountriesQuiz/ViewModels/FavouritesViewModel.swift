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
    var colorButton: UIColor { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    var title: String { get }
    var details: String { get }
    
    init(game: Games, favourites: [Favourites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: FavouritesCell, indexPath: IndexPath)
    func setFavourites(newFavourites: [Favourites])
    func setView(color: UIColor, radius: CGFloat?) -> UIView
    func setLabel(title: String, font: String, size: CGFloat, color: UIColor) -> UILabel
    func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView
    func setDetails(_ viewDetails: UIView,_ view: UIView, and indexPath: IndexPath)
    
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(_ button: UIButton,_ label: UILabel,_ moreInfo: UIButton, on view: UIView)
    func setConstraints(_ indexPath: IndexPath,_ viewDetails: UIView, on view: UIView)
    func setConstraints(_ label: UILabel, and image: UIImageView, on button: UIButton)
    
    func buttonOnOff(button: UIButton, isOn: Bool)
    func buttonOnOff(_ button: UIButton, isOn: Bool,_ view: UIView)
    func showAnimationView(_ viewDetails: UIView,_ visualEffectBlur: UIVisualEffectView)
    func hideAnimationView(_ viewDetails: UIView,_ visualEffectBlur: UIVisualEffectView)
    
    func detailsViewController() -> DetailsViewModelProtocol
}

class FavouritesViewModel: FavouritesViewModelProtocol {
    var background: UIColor {
        game.favourite
    }
    var backgroundDetails: UIColor {
        game.swap
    }
    var colorButton: UIColor {
        game.background
    }
    var cell: AnyClass = FavouritesCell.self
    var numberOfRows: Int {
        favourites.count
    }
    var heightOfRow: CGFloat = 60
    var title: String = "Избранное"
    var details: String = "Ошибка ответа"
    
    private let game: Games
    private var favourites: [Favourites]
    private var indexPath: IndexPath!
    
    private var viewSecondary: UIView!
    private var subview: UIView!
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
    
    func detailsViewController() -> DetailsViewModelProtocol {
        DetailsViewModel(game: game, favourite: favourites[indexPath.row], favourites: favourites)
    }
    
    func setView(color: UIColor, radius: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setLabel(title: String, font: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: font, size: size)
        label.textColor = color
        label.textAlignment = .center
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
        let favourite = setIndexPath(index: indexPath)
        viewSecondary = setView(color: game.background)
        subview = setName(favourite: favourite)
        stackView = setStackView(favourite, view)
        setSubviews(subviews: viewSecondary, on: viewDetails)
        setSubviews(subviews: subview, stackView, on: viewSecondary)
        setConstraints(favourite: favourite, on: viewDetails)
    }
    // MARK: - Constraints
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: sizes),
            button.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func setConstraints(_ button: UIButton, _ label: UILabel, _ moreInfo: UIButton,
                        on view: UIView) {
        setSquare(button: button, sizes: 40)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 26)
        ])
        
        NSLayoutConstraint.activate([
            moreInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moreInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moreInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moreInfo.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setConstraints(_ indexPath: IndexPath, _ viewDetails: UIView, on view: UIView) {
        let constant: CGFloat = favourites[indexPath.row].isFlag ? 0.645 : 0.5
        NSLayoutConstraint.activate([
            viewDetails.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewDetails.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: constant),
            viewDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            viewDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    func setConstraints(_ label: UILabel, and image: UIImageView, on button: UIButton) {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -12)
        ])
    }
    // MARK: - Show / hide subviews
    func buttonOnOff(button: UIButton, isOn: Bool) {
        let opacity: Float = isOn ? 1 : 0
        isEnabled(buttons: button, isOn: isOn)
        setOpacityButtons(buttons: button, opacity: opacity)
    }
    
    func buttonOnOff(_ button: UIButton, isOn: Bool, _ view: UIView) {
        let opacity: Float = isOn ? 1 : 0
        isEnabled(buttons: button, isOn: isOn)
        setOpacityButtons(buttons: button, opacity: opacity)
        isOn ? setConstraints(button: button, on: view) : deactivateConstraints(button: button, on: view)
    }
    
    func showAnimationView(_ viewDetails: UIView, _ visualEffectBlur: UIVisualEffectView) {
        viewDetails.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        viewDetails.alpha = 0
        UIView.animate(withDuration: 0.5) {
            visualEffectBlur.alpha = 1
            viewDetails.alpha = 1
            viewDetails.transform = .identity
        }
    }
    
    func hideAnimationView(_ viewDetails: UIView, _ visualEffectBlur: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5) {
            visualEffectBlur.alpha = 0
            viewDetails.alpha = 0
            viewDetails.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { _ in
            self.removeSubviews(subviews: viewDetails, self.viewSecondary, 
                                self.subview, self.stackView)
        }
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
    
    private func setImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = radius ?? 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setStackView(_ favourite: Favourites, _ view: UIView) -> UIStackView {
        let first = setView(favourite, favourite.buttonFirst, and: 1, view: view)
        let second = setView(favourite, favourite.buttonSecond, and: 2, view: view)
        let third = setView(favourite, favourite.buttonThird, and: 3, view: view)
        let fourth = setView(favourite, favourite.buttonFourth, and: 4, view: view)
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
    
    private func setView(_ favourite: Favourites, _ name: String,
                         and tag: Int, view: UIView) -> UIView {
        let background = backgroundColor(favourite, name, and: tag)
        let button = setView(color: background, radius: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        addSubviews(button, favourite, name, and: tag, view)
        return button
    }
    
    private func addSubviews(_ button: UIView, _ favourite: Favourites, 
                             _ name: String, and tag: Int, _ view: UIView) {
        if game.gameType == .questionnaire {
            let subview = subview(favourite, name, and: tag)
            let checkmark = setImage(image: checkmark(favourite, name, tag),
                                     color: color(favourite, name, tag), size: 26)
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
            return setImage(image: name, radius: 8)
        }
    }
}
// MARK: - Show / hide subviews
extension FavouritesViewModel {
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
    
    private func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
// MARK: - Constants
extension FavouritesViewModel {
    private func setIndexPath(index: IndexPath) -> Favourites {
        indexPath = index
        return favourites[indexPath.row]
    }
    
    private func backgroundColor(_ favourite: Favourites, _ name: String,
                                 and tag: Int) -> UIColor {
        question(favourite) == name ? correctBackground() : incorrectBackground(favourite, tag)
    }
    
    private func question(_ favourite: Favourites) -> String {
        switch game.gameType {
        case .quizOfCapitals: favourite.capital
        default: favourite.isFlag ? favourite.name : favourite.flag
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
        question(favourite) == name ? "checkmark.circle.fill" : incorrectCheckmark(favourite, tag)
    }
    
    private func incorrectCheckmark(_ favourite: Favourites, _ tag: Int) -> String {
        favourite.tag == tag ? "xmark.circle.fill" : "circle"
    }
    
    private func color(_ favourite: Favourites, _ name: String,
                       _ tag: Int) -> UIColor {
        question(favourite) == name ? .greenHarlequin : incorrectColor(favourite, tag)
    }
    
    private func incorrectColor(_ favourite: Favourites, _ tag: Int) -> UIColor {
        favourite.tag == tag ? .redTangerineTango : .white
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
    
    private func setHeight(_ favourite: Favourites) -> CGFloat {
        let buttonHeight = (height(favourite) - 4) / 2
        return buttonHeight - 10
    }
    
    private func widthImage(_ favourite: Favourites, _ flag: String, 
                            _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight(favourite)
        default: return setWidth(view)
        }
    }
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func height(_ favourite: Favourites) -> CGFloat {
        favourite.isFlag ? 205 : 225
    }
}
// MARK: - Constraints
extension FavouritesViewModel {
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
    
    private func setConstraints(favourite: Favourites, on view: UIView) {
        NSLayoutConstraint.activate([
            viewSecondary.topAnchor.constraint(equalTo: view.topAnchor, constant: 52),
            viewSecondary.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSecondary.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewSecondary.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -53)
        ])
        
        if favourite.isFlag {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.centerXAnchor.constraint(equalTo: viewSecondary.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: width(favourite.flag)),
                subview.heightAnchor.constraint(equalToConstant: 168)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 10),
                subview.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -10)
            ])
        }
        
        let constant: CGFloat = favourite.isFlag ? 15 : 7.5
        let height: CGFloat = height(favourite)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: subview.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            stackView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setConstraints(button: UIButton, on view: UIView) {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 25)
        ])
    }
    
    private func deactivateConstraints(button: UIButton, on view: UIView) {
        NSLayoutConstraint.deactivate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 25)
        ])
    }
}
