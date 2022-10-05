//
//  ContentView.swift
//  Request
//
//  Created by Tomasz Gieburowski on 03/10/2022.
//

import SwiftUI

struct ContentView: View {
    @State var memes: [Meme] = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("fetch memes") {
                fetchFilms() {
                    response in
                    memes.append(contentsOf: response)
                    print("pierwszy mem \(memes[0].name)")
                }
            }
            
            List(memes, id: \.id) { meme in
                Text(meme.name)
            }
        }
        .padding()
    }
    
    func fetchFilms(completionHandler: @escaping([Meme]) -> Void) {
        let url = URL(string: "https://api.imgflip.com/get_memes") // wrong address do not couses crash
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error accessing swapi.co: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let
                memesData = try? JSONDecoder().decode(Response.self, from: data) {
                print("I'm in meme summary")
                completionHandler(memesData.data.memes)
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

struct Response: Codable {
    let data: DataSummary
}

struct DataSummary: Codable {
    let memes: [Meme]
}

struct Meme: Codable {
    let id: Int
    let name: String
    let url: String
}

