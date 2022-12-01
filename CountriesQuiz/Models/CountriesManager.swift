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
}
