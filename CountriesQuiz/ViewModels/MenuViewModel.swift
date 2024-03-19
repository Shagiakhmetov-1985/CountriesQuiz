//
//  MenuViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.03.2024.
//

import UIKit

protocol MenuViewModelProtocol {
    var mode: Setting? { get set }
    var games: [Games] { get set }
    func fetchData()
    func size(view: UIView) -> CGSize
    func gameTypeViewModel(tag: Int) -> GameTypeViewModelProtocol
}

class MenuViewModel: MenuViewModelProtocol {
    var mode: Setting?
    var games: [Games] = []
    
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
}
