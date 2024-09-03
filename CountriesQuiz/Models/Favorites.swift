//
//  Favorites.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2024.
//

import Foundation

struct Favorites: Codable {
    let flag: String
    let name: String
    let capital: String
    let continent: String
    let buttonFirst: String
    let buttonSecond: String
    let buttonThird: String
    let buttonFourth: String
    let tag: Int
    let isFlag: Bool
    let isTimeUp: Bool
}
