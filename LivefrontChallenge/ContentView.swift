//
//  ContentView.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import SwiftUI


struct ContentView: View {
    let article = AIArticle(body: "XRP")
    var body: some View {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)

               NavigationLink(article.body, value: Route.detail(article))
            }
            .navigationTitle("Hello World")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
