//
//  MenuViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.03.2024.
//

import UIKit

protocol MenuViewModelProtocol {
    var mode: Setting? { get set }
    func fetchData()
    func size(view: UIView) -> CGSize
    func gameTypeViewModel(tag: Int) -> GameTypeViewModelProtocol
    func forPresented(_ button: UIButton) -> Transition
    func forDismissed(_ button: UIButton) -> Transition
    func setMode(_ setting: Setting)
}

class MenuViewModel: MenuViewModelProtocol {
    var mode: Setting?
    private var games: [Games] = []
    private let transition = Transition()
    
    func fetchData() {
        mode = StorageManager.shared.fetchSetting()
        games = getGames()
    }
    
    func size(view: UIView) -> CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 10)
    }
    
    func gameTypeViewModel(tag: Int) -> GameTypeViewModelProtocol {
        let mode = mode ?? Setting.getSettingDefault()
        let game = games[tag]
        return GameTypeViewModel(mode: mode, game: game, tag: tag)
    }
    
    private func getGames() -> [Games] {
        var games: [Games] = []
        
        let gameType = GameType.shared.gameType
        let names = GameType.shared.names
        let images = GameType.shared.images
        let descriptions = GameType.shared.descriptions
        let backgrounds = GameType.shared.backgrounds
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
                play: plays[index],
                favourite: favourites[index],
                swap: swaps[index],
                done: dones[index])
            games.append(information)
        }
        
        return games
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
}
