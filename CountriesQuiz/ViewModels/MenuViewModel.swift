//
//  MenuViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.03.2024.
//

import UIKit

protocol MenuViewModelProtocol {
    var mode: Setting? { get set }
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func fetchData()
    func size(view: UIView?) -> CGSize
    func forPresented(_ button: UIButton) -> Transition
    func forDismissed(_ button: UIButton) -> Transition
    func setMode(_ setting: Setting)
    
    func gameTypeViewModel(tag: Int) -> GameTypeViewModelProtocol
    func settingViewModel() -> SettingViewModelProtocol
    
    func setSquare(subview: UIView, sizes: CGFloat)
    func setCenterSubview(subview: UIView, on subviewOther: UIView)
    func setConstraintsList(button: UIButton, image: UIImageView, label: UILabel,
                            circle: UIImageView, imageGame: UIImageView,
                            layout: NSLayoutYAxisAnchor, view: UIView)
}

class MenuViewModel: MenuViewModelProtocol {
    var mode: Setting?
    private var games: [Games] = []
    private var favourites: [Favourites] = []
    private let transition = Transition()
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func fetchData() {
        mode = StorageManager.shared.fetchSetting()
        games = getGames()
    }
    
    func size(view: UIView?) -> CGSize {
        guard let view = view else { return CGSize(width: 0, height: 0) }
        return CGSize(width: view.frame.width, height: view.frame.height + 5)
    }
    
    func gameTypeViewModel(tag: Int) -> GameTypeViewModelProtocol {
        let mode = mode ?? Setting.getSettingDefault()
        let game = games[tag]
        favourites = StorageManager.shared.fetchFavourites(key: game.keys)
        return GameTypeViewModel(mode: mode, game: game, tag: tag, favourites: favourites)
    }
    
    func forPresented(_ button: UIButton) -> Transition {
        transition.transitionMode = .present
        transition.startingPoint = button.center
        return transition
    }
    
    func forDismissed(_ button: UIButton) -> Transition {
        transition.transitionMode = .dismiss
        transition.startingPoint = button.center
        return transition
    }
    
    func setMode(_ setting: Setting) {
        mode = setting
    }
    
    func settingViewModel() -> SettingViewModelProtocol {
        let mode = mode ?? Setting.getSettingDefault()
        return SettingViewModel(mode: mode)
    }
    
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func setCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    func setConstraintsList(button: UIButton, image: UIImageView, label: UILabel, 
                            circle: UIImageView, imageGame: UIImageView,
                            layout: NSLayoutYAxisAnchor, view: UIView) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layout, constant: 15),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: button.topAnchor),
            circle.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        setCenterSubview(subview: imageGame, on: circle)
    }
}

extension MenuViewModel {
    private func getGames() -> [Games] {
        var games: [Games] = []
        
        let gameType = GameType.shared.gameType
        let names = GameType.shared.names
        let images = GameType.shared.images
        let descriptions = GameType.shared.descriptions
        let backgrounds = GameType.shared.backgrounds
        let keys = GameType.shared.keys
        let plays = GameType.shared.buttonsPlay
        let favourites = GameType.shared.buttonsFavourite
        let swaps = GameType.shared.buttonsSwap
        let dones = GameType.shared.buttonsDone
        let iterrationCount = min(names.count, images.count, descriptions.count,
                                  backgrounds.count, plays.count,
                                  favourites.count, swaps.count)
        
        for index in 0..<iterrationCount {
            let information = Games(
                gameType: gameType[index],
                name: names[index],
                image: images[index],
                description: descriptions[index],
                background: backgrounds[index], 
                keys: keys[index],
                play: plays[index],
                favourite: favourites[index],
                swap: swaps[index],
                done: dones[index])
            games.append(information)
        }
        
        return games
    }
}
