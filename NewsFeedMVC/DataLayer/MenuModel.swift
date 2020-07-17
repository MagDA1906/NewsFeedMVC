//
//  MenuModel.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 24/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit
// TODO: Add NationalPrijects
enum MenuModel: Int, CustomStringConvertible {
    
    case AllNews
    case Russia
    case World
    case FormerUSSR
    case Economy
    case StrongStructure
    case ScienceAndTechnology
    case TheCulture
    case Sport
    case InternetAndMedia
    case Values
    case Travels
    case FromLife
    case House
    
    var description: String {
        switch self {
        case .AllNews: return "Картина дня"
        case .Russia: return "Россия"
        case .World: return "Мир"
        case .FormerUSSR: return "Бывший СССР"
        case .Economy: return "Экономика"
        case .StrongStructure: return "Силовые структуры"
        case .ScienceAndTechnology: return "Наука и техника"
        case .TheCulture: return "Культура"
        case .Sport: return "Спорт"
        case .InternetAndMedia: return "Интернет и СМИ"
        case .Values: return "Ценности"
        case .Travels: return "Путешествия"
        case .FromLife: return "Из жизни"
        case .House: return "Дом"
        }
    }
    
    var image: UIImage {
        switch self {
        case .AllNews: return UIImage(named: "AllNews") ?? UIImage()
        case .Russia: return UIImage(named: "Russia") ?? UIImage()
        case .World: return UIImage(named: "World") ?? UIImage()
        case .FormerUSSR: return UIImage(named: "FormerUSSR") ?? UIImage()
        case .Economy: return UIImage(named: "Economy") ?? UIImage()
        case .StrongStructure: return UIImage(named: "StrongStructure") ?? UIImage()
        case .ScienceAndTechnology: return UIImage(named: "ScienceAndTechnology") ?? UIImage()
        case .TheCulture: return UIImage(named: "TheCulture") ?? UIImage()
        case .Sport: return UIImage(named: "Sport") ?? UIImage()
        case .InternetAndMedia: return UIImage(named: "InternetAndMedia") ?? UIImage()
        case .Values: return UIImage(named: "Values") ?? UIImage()
        case .Travels: return UIImage(named: "Travels") ?? UIImage()
        case .FromLife: return UIImage(named: "FromLife") ?? UIImage()
        case .House: return UIImage(named: "House") ?? UIImage()
        }
    }
}
