//
//  SavedTranslationView.swift
//  TranslateMe
//
//  Created by Admin on 4/1/24.
//

import Foundation
import SwiftUI

struct WordPair: Hashable {
    let left: String
    let right: String
}

struct SavedTranslationView: View {
    @State private var wordPairs = [
        WordPair(left: "Hello", right: "Holla"),
        WordPair(left: "How are you", right: "Comment-allez vous"),
        WordPair(left: "How old are you", right: "Tea Green")
    ]

    var body: some View {
        VStack {
            List {
                ForEach(wordPairs, id: \.self) { pair in
                    VStack {
                        Text(pair.left)
                            .padding()
                            .foregroundColor(.blue)
                        Spacer()
                        Text(pair.right)
                            .padding()
                            .foregroundColor(.green)
                    }
                }
            }
            
            Button(action: {
                // Clear all translations
                wordPairs = []
            }) {
                Text("Clear All Translations")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SavedTranslationView()
    }
}
