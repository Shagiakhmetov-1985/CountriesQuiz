//
//  GameType.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

class GameType {
    static let shared = GameType()
    
    let gameType: [TypeOfGame] = [.quizOfFlags, .questionnaire, .quizOfMaps,
                                  .scrabble, .quizOfCapitals]
    
    let names = ["Викторина флагов", "Опрос", "Викторина карт", "Эрудит",
                 "Викторина столиц"]
    
    let images = ["filemenu.and.selection", "checklist", "globe.desk",
                  "a.square", "building.2"]
    
    let descriptions = [
        "Выбор ответа на заданный вопрос о флаге страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный.",
        "Опрос о флагах стран и выбор ответов во всем опросе. Вам предоставляются четыре ответа на выбор. Вы можете выбрать один ответ и один из четырех ответов - правильный.",
        "Выбор ответа на заданный вопрос о географической карте страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный.",
        "Составление слова из недостающих букв. Вам представлены буквы случайным образом. Для перехода к следующему вопросу, вы должны полностью составить слово из букв.",
        "Выбор ответа на заданный вопрос о столице страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный."]
    
    let keys = ["quizOfFlags", "questionnaire", "quizOfMaps" , "scrabble", "quizOfCapitals"]
    
    let bulletsQuizOfFlags = [
        "Одна попытка для выбора ответа, чтобы перейти к следующему вопросу.",
        "Вопрос о флаге страны и выбор ответа наименования страны или же вопрос о наименовании страны и выбор ответа флага страны.",
        "Зеленый цвет - правильный ответ и красный цвет - неправильный ответ.",
        "Обратный отсчет для одного вопроса, который восстанавливается при следующем вопросе.",
        "Обратный отсчет для всех вопросов, который не восстанавливается при следующем вопросе."
    ]
    
    let bulletsQuestionnaire = [
        "Любое количество попыток для выбора ответа, чтобы перейти к следующему вопросу.",
        "Возможность вернуться к предыдущим вопросам для выбора другого ответа.",
        "Вопрос о флаге страны и выбор ответа наименования страны или же вопрос о наименовании страны и выбор ответа флага страны.",
        "О правильных и неправильных ответах узнаете только после окончания опроса.",
        "Игра завершается при касании экрана в последнем вопросе.",
        "Обратный отсчет только для всех вопросов и не восстанавливается до конца игры."
    ]
    
    let bulletsQuizOfMaps = [
        "Одна попытка для выбора ответа, чтобы перейти к следующему вопросу.",
        "Зеленый цвет - правильный ответ и красный цвет - неправильный ответ.",
        "Выбор обратного отсчета для одного вопроса, который восстанавливается при следующем вопросе.",
        "Выбор обратного отсчета для всех вопросов, который не восстанавливается при следующем вопросе."
    ]
    
    let bulletsScrabble = [
        "Одна попытка для выбора ответа, чтобы перейти к следующему вопросу.",
        "Вопрос о флаге страны / о географической карты страны / о столице страны",
        "Зеленый цвет - правильный ответ и красный цвет - неправильный ответ.",
        "Обратный отсчет для одного вопроса, который восстанавливается при следующем вопросе.",
        "Обратный отсчет для всех вопросов, который не восстанавливается при следующем вопросе."
    ]
    
    let bulletsQuizOfCapitals = [
        "Одна попытка для выбора ответа, чтобы перейти к следующему вопросу.",
        "Вопрос о флаге страны и выбор ответа столицы страны или же вопрос о наименовании страны и выбор ответа столицы страны.",
        "Зеленый цвет - правильный ответ и красный цвет - неправильный ответ.",
        "Обратный отсчет для одного вопроса, который восстанавливается при следующем вопросе.",
        "Обратный отсчет для всех вопросов, который не восстанавливается при следующем вопросе."
    ]
    
    let backgrounds: [UIColor] = [.cyanDark, .greenHarlequin, .redYellowBrown,
                                  .indigo, .redTangerineTango]
    
    let buttonsPlay: [UIColor] = [.skyBlueLight, .greenYellowBrilliant,
                                  .redBeige, .fuchsiaCrayolaDeep, .redCardinal]
    
    let buttonsFavourite: [UIColor] = [.blueMiddlePersian, .greenEmerald, .brown,
                                       .amethyst, .bismarkFuriozo]
    
    let buttonsSwap: [UIColor] = [.blueBlackSea, .greenDartmouth, .brownDeep,
                                  .blueSlate, .brownRed]
    
    let buttonsDone: [UIColor] = [.skyCyanLight, .greenWhite, .somon,
                                  .veryLightPurple, .salmon]
    
    private init() {}
}

enum TypeOfGame {
    case quizOfFlags
    case questionnaire
    case quizOfMaps
    case scrabble
    case quizOfCapitals
}
