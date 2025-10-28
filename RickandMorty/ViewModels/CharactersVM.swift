//
//  CharactersVM.swift
//  RickandMorty
//
//  Created by francisco eduardo aramburo reyes on 23/10/25.
//

import Foundation
import SwiftUI
import Combine

enum LoadState: Equatable {
    case idle, loading, loaded, failed(String)
}

@MainActor
final class CharactersVM: ObservableObject {
    @Published var selectedResource: ResourceType = .characters
    @Published var characters: [RMCharacter] = []
    @Published var episodes: [Episode] = []
    @Published var locations: [Location] = []
    @Published var info: Info? = nil
    @Published var state: LoadState = .idle
    @Published var searchText: String = ""

    private let api = APIClient()
    private var currentPage: Int = 1
    private var currentTask: Task<Void, Never>?

    func firstLoad() async {
        await load(page: 1, name: nil)
    }

    func applySearch() async {
        currentPage = 1
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }

    func nextPage() async {
        guard let i = info, i.next != nil else { return }
        currentPage += 1
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }

    func prevPage() async {
        guard let i = info, i.prev != nil else { return }
        currentPage = max(1, currentPage - 1)
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }
    
    func load(page: Int?, name: String?) async {
        currentTask?.cancel()
        
        currentTask = Task {
            state = .loading
            
            do {
                switch selectedResource {
                case .characters:
                    let resp = try await api.fetchCharacters(page: page, name: name)
                    if Task.isCancelled { return }
                    characters = resp.results
                    info = resp.info
                    
                case .episodes:
                    let resp = try await api.fetchEpisodes(page: page, name: name)
                    if Task.isCancelled { return }
                    episodes = resp.results
                    info = resp.info
                    
                case .locations:
                    let resp = try await api.fetchLocations(page: page, name: name)
                    if Task.isCancelled { return }
                    locations = resp.results
                    info = resp.info
                }
                
                if !Task.isCancelled {
                    state = .loaded
                }
            } catch {
                if !Task.isCancelled {
                    state = .failed(error.localizedDescription)
                }
            }
        }
    }
}
