//
//  ContentView.swift
//  Request
//
//  Created by Tomasz Gieburowski on 03/10/2022.
//

import SwiftUI

struct ContentView: View {
    @State var films: [Film] = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("fetch films") {
                fetchFilms() {
                    response in
                    films.append(contentsOf: response)
                }
            }
            
            List(films, id: \.title) { film in
                /*@START_MENU_TOKEN@*/Text(film.title)/*@END_MENU_TOKEN@*/
            }
        }
        .padding()
    }
    
    func fetchFilms(completionHandler: @escaping([Film]) -> Void) {
        let url = URL(string: "https://swapi.dev/api/films")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error accessing swapi.co: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let filmSummary = try? JSONDecoder().decode(FilmSummary.self, from: data) {
                completionHandler(filmSummary.results)
            }
        })
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FilmSummary: Codable {
    let count: Int
    let results: [Film]
}

struct Film: Codable{
    let title: String
}

struct Meme: Codable {
    let id: Int
    let name: String
    let url: String
    let width: Int
    let height: Int
    let box_count: Int
}

