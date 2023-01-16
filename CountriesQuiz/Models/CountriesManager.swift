//
//  CountriesManager.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import Foundation

struct Countries {
    let flag: String
    let name: String
}

extension Countries {
    static func getCountries() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.images
        let names = FlagsOfCountries.shared.countries
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAmericanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAmericanContinent
        let names = FlagsOfCountries.shared.countriesOfAmericanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getEuropeanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfEuropeanContinent
        let names = FlagsOfCountries.shared.countriesOfEuropeanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAfricanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAfricanContinent
        let names = FlagsOfCountries.shared.countriesOfAfricanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAsianContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAsianContinent
        let names = FlagsOfCountries.shared.countriesOfAsianContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getOceanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfOceanContinent
        let names = FlagsOfCountries.shared.countriesOfOceanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getRandomCountries() -> [Countries] {
        var randomCountries = randomCountries()
        let setting = StorageManager.shared.fetchSetting()
        
        var getCountries: [Countries] = []
        for index in 0..<setting.countQuestions {
            getCountries.append(randomCountries[index])
        }
        randomCountries.removeAll()
        
        return getCountries
    }
    
    static func randomCountries() -> [Countries] {
        var countries: [Countries] = []
        let setting = StorageManager.shared.fetchSetting()
        
        countries = allCountries(toggle: setting.allCountries) +
        americanContinent(toggle: setting.americaContinent) +
        europeContinent(toggle: setting.europeContinent) +
        africaContinent(toggle: setting.africaContinent) +
        asiaContinent(toggle: setting.asiaContinent) +
        oceanContinent(toggle: setting.oceaniaContinent)
        
        countries.shuffle()
        
        return countries
    }
    
    static func allCountries(toggle: Bool) -> [Countries] {
        toggle ? Countries.getCountries() : []
    }
    
    static func americanContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAmericanContinent() : []
    }
    
    static func europeContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getEuropeanContinent() : []
    }
    
    static func africaContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAfricanContinent() : []
    }
    
    static func asiaContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAsianContinent() : []
    }
    
    static func oceanContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getOceanContinent() : []
    }
    
    static func getAnswers(correctAnswers: [Countries]) -> [Countries] {
        var answers: [Countries] = []
        let randomCountries = randomCountries()
        
        
        return answers
    }
}
