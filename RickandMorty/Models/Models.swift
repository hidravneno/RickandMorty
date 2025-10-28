//
//  Models.swift
//  RickandMorty
//
//  Created by francisco eduardo aramburo reyes on 23/10/25.
//

import Foundation

// MARK: - Shared Info
public struct Info: Codable, Hashable {
    public let count: Int
    public let pages: Int
    public let next: String?
    public let prev: String?
}

// MARK: - Characters
public struct CharactersResponse: Codable, Hashable {
    public let info: Info
    public let results: [RMCharacter]
}

public struct RMCharacter: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let image: String
    public let episode: [String]
}

// MARK: - Episodes
public struct EpisodesResponse: Codable, Hashable {
    public let info: Info
    public let results: [Episode]
}

public struct Episode: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let air_date: String
    public let episode: String
    public let characters: [String]
}

// MARK: - Locations
public struct LocationsResponse: Codable, Hashable {
    public let info: Info
    public let results: [Location]
}

public struct Location: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let type: String
    public let dimension: String
    public let residents: [String]
}

// MARK: - Resource Type
public enum ResourceType: String, CaseIterable {
    case characters = "Characters"
    case episodes = "Episodes"
    case locations = "Locations"
    
    var endpoint: String {
        switch self {
        case .characters: return "character"
        case .episodes: return "episode"
        case .locations: return "location"
        }
    }
}
