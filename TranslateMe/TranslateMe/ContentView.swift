//
//  ContentView.swift
//  TranslateMe
//
//  Created by Admin on 4/1/24.
//

import SwiftUI

//struct ContentView: View {
//    @State private var text = ""
//    @State private var selectLanguage = "Select Language" // Provide a default value
//
//    var body: some View {
//        NavigationStack{
//            
//            VStack {
//
//                    
//                TextField("Enter text", text: $text)
//                    .padding()
//                    .frame(minWidth: 0, maxWidth: 370, maxHeight: 35)
//                    .background(Color.white) // Set background color
//                    .cornerRadius(10) // Set corner radius
//                    
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray, lineWidth: 1) // Add border around the TextField
//                    )
//                    .padding(.bottom, 30)
//                
//                
//                HStack{
//                    Button(action: {
//                        
//                    }) {
//                        Text("Translate Me")
//                            .padding()
//                            .foregroundColor(.white)
//                            .font(.headline)
//                    }
//                    .frame(maxWidth: 200)
//                    .frame(height: 50)
//                    .background(Color.blue)
//                    .cornerRadius(16)
//                    .padding(.bottom, 15)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        
//                    }) {
//                        Picker("Select Language", selection: $selectLanguage) {
//                            Text("Spanish")
//                                .foregroundColor(.white) // Set text color to white
//                            Text("French")
//                                .foregroundColor(.white) // Set text color to white
//                            Text("Portuguese")
//                                .foregroundColor(.white) // Set text color to white
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                    }
//                    .frame(maxWidth: 200)
//                    .frame(height: 50)
//                    .background(Color.gray)
//                    .cornerRadius(16)
//                    .padding(.bottom, 15)
//                    
//                }
//    
//                    
//                    TextField("", text: $text)
//                    .padding()
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
//                    .background(Color.white) // Set background color
//                    .cornerRadius(10) // Set corner radius
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.blue, lineWidth: 1) // Add border around the TextField
//                    )
//                
//                }
//            .padding(.top, 170)
//            Spacer() // Spacer to push the button to the bottom
//            NavigationLink(destination: SavedTranslationView()) {
//                Text("View Saved Translations")
//                    .padding()
//                    .foregroundColor(.blue)
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 50)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .padding()
//            }
//            
//            .navigationTitle("Translate Me")
//            .padding()
//        }
//        
//        
//    }
//}
//
struct ContentView: View {
    @State var text: String = ""
    @State var translatedText: String = ""
    @State private var selectLanguage = ""
    
    enum Language {
        case english
        case spanish
        case french
        case portuguese
    }
    
    var body: some View {
        NavigationStack{
            Section{
                VStack {
                    
                    
                    TextField("Enter text", text: $text)
                        .padding()
                        .frame(minWidth: 0, maxWidth: 370, maxHeight: 35)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 30)
                    
                    HStack{
                        Button(action: {
                            fetchTranslation()
                        }) {
                            Text("Translate Me")
                                .padding()
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .frame(maxWidth: 200)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(16)
                        .padding(.bottom, 15)
                        
                        //Spacer()
                        
                        Picker("Select Language", selection: $selectLanguage) {
                            Text("Spanish").tag("Spanish")
                                .foregroundColor(.white)
                            Text("French").tag("French")
                                .foregroundColor(.white)
                            Text("Portuguese").tag("Portuguese")
                                .foregroundColor(.white)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 200)
                        .frame(height: 50)
                        .background(.gray)
                        .cornerRadius(16)
                        .padding(.bottom, 15)
                    }
                    
                    TextField("", text: $translatedText)
                    
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        .disabled(true)
                    Spacer()
                    //.padding(.bottom, 200)
                }
                .padding(.top, 150)
            }
            NavigationLink(destination: SavedTranslationView()) {
                
              Text("View Saved Translations")
                    .padding()
                  .foregroundColor(.blue)
                  .font(.headline)
                  .frame(maxWidth: .infinity)
                  .frame(height: 16)
                  .background(Color.white)
                  .cornerRadius(10)
                  
          }
            
            .navigationTitle("Translate Me")
            
        }
    }
    
    // Define a mapping function from ContentView.Language to MyMemoryLanguageOption
    func mapToMyMemoryLanguageOption(language: ContentView.Language) -> MyMemoryLanguageOption {
        switch language {
            case .french: return .french
            case .spanish: return .spanish
            case .portuguese: return .portuguese
            
        default:  return .spanish
        }
    }

    // Usage of the mapping function in fetchTranslation
    func fetchTranslation() {
        guard !text.isEmpty else { return }
        
        // Convert selectLanguage to ContentView.Language
        let selectedLanguage: ContentView.Language
        switch selectLanguage {
            case "Spanish": selectedLanguage = .spanish
            case "French": selectedLanguage = .french
            case "Portuguese": selectedLanguage = .portuguese
            default: return
        }
        
        // Map ContentView.Language to MyMemoryLanguageOption
        let outputLanguage = mapToMyMemoryLanguageOption(language: selectedLanguage)
        
        URLSession.shared.dataTask(with: makeMemoryUrlFor(MyMemoryBaseRequest(
            query: text,
            sourceLanguage: .english,
            outputLanguage: outputLanguage
        ))) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let myResponse: MyMemoryTranslateResponse = try decoder.decode(MyMemoryTranslateResponse.self, from: data)
                let translation = myResponse.matches.first?.translation ?? ""
                translatedText = translation
            } catch let decodingError {
                print(decodingError)
            }
        }.resume()
    }
}



#Preview {
    ContentView()
}
