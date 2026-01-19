//
//  MediaView.swift
//  PredictiveSearch
//
//  Created by m47145 on 17/01/2026.
//

import SwiftUI

struct MediaView: View {
    @StateObject private var viewModel: MediaSearchViewModel
    @State private var searchTerm: String = ""

    init(viewModel: MediaSearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.results) { item in
                    HStack {
                        AsyncImage(url: item.artworkURL) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.artist)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("iTunes Search")
            .searchable(text: $searchTerm, prompt: "Search for music...")
            .onChange(of: searchTerm) { oldValue, newValue in
                viewModel.searchTermChanged(to: newValue)
            }
        }
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(viewModel: MediaSearchViewModel(repository: MediaRepository()))    }
}
