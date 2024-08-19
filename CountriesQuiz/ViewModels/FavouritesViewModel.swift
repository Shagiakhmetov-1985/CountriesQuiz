//
//  FavouritesViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.08.2024.
//

import UIKit

protocol FavouritesViewModelProtocol {
    var background: UIColor { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    
    init(game: Games, favourites: [Favourites])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func customCell(cell: FavouritesCell, indexPath: IndexPath)
}

class FavouritesViewModel: FavouritesViewModelProtocol {
    var background: UIColor {
        game.background
    }
    var cell: AnyClass = FavouritesCell.self
    var numberOfRows: Int {
        favourites.count
    }
    var heightOfRow: CGFloat = 60
    
    private let game: Games
    private let favourites: [Favourites]
    
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
    }
}
