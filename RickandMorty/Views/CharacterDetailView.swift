//
//  CharacterDetailView.swift
//  RickandMorty
//
//  Created by francisco eduardo aramburo reyes on 24/10/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    @State private var note = ""
    @State private var showSavedMessage = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            
            ScrollView {
                VStack(spacing: 24) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text(character.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Status")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(character.status)
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                        }
                        
                        Divider().background(Color.gray)
                        
                        HStack {
                            Text("Species")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(character.species)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        
                        Divider().background(Color.gray)
                        
                        HStack {
                            Text("Episodes")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(character.episode.count)")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextEditor(text: $note)
                            .frame(height: 100)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .tint(.black)
                        
                        Button(action: saveNote) {
                            HStack {
                                Image(systemName: showSavedMessage ? "checkmark.circle.fill" : "square.and.arrow.down")
                                Text(showSavedMessage ? "Saved!" : "Save Note")
                            }
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(showSavedMessage ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .animation(.easeInOut, value: showSavedMessage)
                        }
                        .disabled(showSavedMessage)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            note = UserDefaults.standard.string(forKey: "rm_note_\(character.id)") ?? ""
        }
    }
    
    private func saveNote() {
        UserDefaults.standard.set(note, forKey: "rm_note_\(character.id)")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showSavedMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSavedMessage = false
        }
    }
}
