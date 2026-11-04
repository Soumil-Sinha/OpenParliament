//
//  Vocabulary.swift
//  OpenParliament
//
//  Terms shared across members, bills and schemes.
//

import Foundation

enum House: String, CaseIterable, Hashable, Identifiable {
    case lokSabha = "Lok Sabha"
    case rajyaSabha = "Rajya Sabha"

    var id: String { rawValue }
}

enum Party: String, CaseIterable, Hashable, Identifiable {
    case nationalProgressive = "National Progressive Party"
    case unitedDemocratic = "United Democratic Front"
    case regionalPeoples = "Regional People's Party"
    case janhitMorcha = "Janhit Morcha"
    case independent = "Independent"

    var id: String { rawValue }

    var abbreviation: String {
        switch self {
        case .nationalProgressive: "NPP"
        case .unitedDemocratic: "UDF"
        case .regionalPeoples: "RPP"
        case .janhitMorcha: "JM"
        case .independent: "IND"
        }
    }
}
