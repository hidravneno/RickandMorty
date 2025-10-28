//  ContentView.swift
//  RickandMorty
//
//  Created by francisco eduardo aramburo reyes on 23/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = CharactersVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Rick & Morty")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 40)
                    
                    Picker("Resource", selection: $vm.selectedResource) {
                        ForEach(ResourceType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.selectedResource) {
                        vm.searchText = ""
                        Task { await vm.firstLoad() }
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search", text: $vm.searchText)
                                .foregroundColor(.white)
                                .onSubmit {
                                    Task { await vm.applySearch() }
                                }
                            
                            if !vm.searchText.isEmpty {
                                Button(action: {
                                    vm.searchText = ""
                                    Task { await vm.applySearch() }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6).opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    contentView
                    
                    if vm.state == .loaded {
                        paginationButtons
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .task {
            await vm.firstLoad()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch vm.state {
        case .idle:
            emptyStateView
        case .loading:
            loadingView
        case .loaded:
            resourcesList
        case .failed(let message):
            errorView(message)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Welcome to Rick & Morty")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("Pull down to load")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var resourcesList: some View {
        switch vm.selectedResource {
        case .characters:
            charactersList
        case .episodes:
            episodesList
        case .locations:
            locationsList
        }
    }
    
    private var charactersList: some View {
        ScrollView {
            ForEach(vm.characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: character.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(character.name)
                                .foregroundColor(.white)
                                .font(.headline)
                                .lineLimit(1)
                            
                            HStack(spacing: 6) {
                                Text(character.status)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(statusBackgroundColor(character.status))
                                    .foregroundColor(statusTextColor(character.status))
                                    .cornerRadius(8)
                                
                                Text("•")
                                    .foregroundColor(.gray)
                                
                                Text(character.species)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 80)
                }
            }
        }
        .refreshable {
            await vm.firstLoad()
        }
    }
    
    private var episodesList: some View {
        ScrollView {
            ForEach(vm.episodes) { episode in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(episode.episode)
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                        
                        Text(episode.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    Text(episode.air_date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .refreshable {
            await vm.firstLoad()
        }
    }
    
    private var locationsList: some View {
        ScrollView {
            ForEach(vm.locations) { location in
                VStack(alignment: .leading, spacing: 8) {
                    Text(location.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(location.type)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text(location.dimension)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    Text("Residents: \(location.residents.count)")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
                .padding()
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .refreshable {
            await vm.firstLoad()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title)
                .foregroundColor(.white)
            
            Text(message)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task { await vm.firstLoad() }
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var paginationButtons: some View {
        HStack(spacing: 16) {
            Button(action: {
                Task { await vm.prevPage() }
            }) {
                Label("Previous", systemImage: "chevron.left")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
            .disabled(vm.info?.prev == nil)
            .opacity(vm.info?.prev == nil ? 0.5 : 1.0)
            
            Button(action: {
                Task { await vm.nextPage() }
            }) {
                Label("Next", systemImage: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
            .disabled(vm.info?.next == nil)
            .opacity(vm.info?.next == nil ? 0.5 : 1.0)
        }
        .padding(.vertical, 8)
    }
    
    private func statusBackgroundColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "alive": return .green.opacity(0.2)
        case "dead": return .red.opacity(0.2)
        default: return .gray.opacity(0.2)
        }
    }
    
    private func statusTextColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

#Preview {
    ContentView()
}
